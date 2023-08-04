{ callPackage, lib, stdenv, appimageTools, autoPatchelfHook, desktop-file-utils
, fetchurl, libsecret  }:

let
  srcjson = builtins.fromJSON (builtins.readFile ./src.json);
  version = srcjson.version;
  pname = "standardnotes";
  throwSystem = throw "Unsupported system: ${stdenv.hostPlatform.system}";

  src = fetchurl (srcjson.appimage.${stdenv.hostPlatform.system} or throwSystem);

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };

  nativeBuildInputs = [ autoPatchelfHook desktop-file-utils ];

in appimageTools.wrapType2 rec {
  inherit pname version src;

  extraPkgs = pkgs: with pkgs; [
    libsecret
  ];

  extraInstallCommands = ''
    chmod -R +w $out
    mv $out/bin/${pname}-${version} $out/bin/${pname}

    ${desktop-file-utils}/bin/desktop-file-install --dir $out/share/applications \
      --set-key Exec --set-value ${pname} ${appimageContents}/standard-notes.desktop
    ln -s ${appimageContents}/usr/share/icons $out/share
  '';

  passthru.updateScript = callPackage ./update.nix {};

  meta = with lib; {
    description = "A simple and private notes app";
    longDescription = ''
      Standard Notes is a private notes app that features unmatched simplicity,
      end-to-end encryption, powerful extensions, and open-source applications.
    '';
    homepage = "https://standardnotes.org";
    license = licenses.agpl3;
    maintainers = with maintainers; [ mgregoire chuangzhu squalus ];
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    platforms = builtins.attrNames srcjson.appimage;
  };
}
