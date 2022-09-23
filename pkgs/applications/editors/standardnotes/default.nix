{ lib, stdenv, appimageTools, autoPatchelfHook, desktop-file-utils
, fetchurl, libsecret  }:

let
  version = "3.23.69";
  pname = "standardnotes";
  name = "${pname}-${version}";
  throwSystem = throw "Unsupported system: ${stdenv.hostPlatform.system}";

  plat = {
    i686-linux = "i386";
    x86_64-linux = "x86_64";
  }.${stdenv.hostPlatform.system} or throwSystem;

  sha256 = {
    i686-linux = "sha256-/A2LjV8ky20bcKgs0ijwldryi5VkyROwz49vWYXYQus=";
    x86_64-linux = "sha256-fA9WH9qUtvAHF9hTFRtxQdpz2dpK0joD0zX9VYBo10g=";
  }.${stdenv.hostPlatform.system} or throwSystem;

  src = fetchurl {
    url = "https://github.com/standardnotes/app/releases/download/%40standardnotes%2Fdesktop%40${version}/standard-notes-${version}-linux-${plat}.AppImage";
    inherit sha256;
  };

  appimageContents = appimageTools.extract {
    inherit name src;
  };

  nativeBuildInputs = [ autoPatchelfHook desktop-file-utils ];

in appimageTools.wrapType2 rec {
  inherit name src;

  extraPkgs = pkgs: with pkgs; [
    libsecret
  ];

  extraInstallCommands = ''
    # directory in /nix/store so readonly
    cd $out
    chmod -R +w $out
    mv $out/bin/${name} $out/bin/${pname}

    # fixup and install desktop file
    ${desktop-file-utils}/bin/desktop-file-install --dir $out/share/applications \
      --set-key Exec --set-value ${pname} ${appimageContents}/standard-notes.desktop
    ln -s ${appimageContents}/usr/share/icons share
  '';

  meta = with lib; {
    description = "A simple and private notes app";
    longDescription = ''
      Standard Notes is a private notes app that features unmatched simplicity,
      end-to-end encryption, powerful extensions, and open-source applications.
    '';
    homepage = "https://standardnotes.org";
    license = licenses.agpl3;
    maintainers = with maintainers; [ mgregoire chuangzhu ];
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
