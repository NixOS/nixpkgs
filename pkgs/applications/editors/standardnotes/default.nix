{ lib, stdenv, fetchurl, dpkg, makeWrapper, electron, libsecret
, desktop-file-utils , callPackage }:

let

  srcjson = builtins.fromJSON (builtins.readFile ./src.json);

  throwSystem = throw "Unsupported system: ${stdenv.hostPlatform.system}";

in

stdenv.mkDerivation rec {

  pname = "standardnotes";

  src = fetchurl (srcjson.deb.${stdenv.hostPlatform.system} or throwSystem);

  inherit (srcjson) version;

  dontConfigure = true;

  dontBuild = true;

  nativeBuildInputs = [ makeWrapper dpkg desktop-file-utils ];

  unpackPhase = "dpkg-deb --fsys-tarfile $src | tar -x --no-same-permissions --no-same-owner";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/standardnotes
    cp -R usr/share/{applications,icons} $out/share
    cp -R opt/Standard\ Notes/resources/app.asar $out/share/standardnotes/

    makeWrapper ${electron}/bin/electron $out/bin/standardnotes \
      --add-flags $out/share/standardnotes/app.asar \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libsecret stdenv.cc.cc.lib ]}

    ${desktop-file-utils}/bin/desktop-file-install --dir $out/share/applications \
      --set-key Exec --set-value standardnotes usr/share/applications/standard-notes.desktop

    runHook postInstall
  '';

  passthru.updateScript = callPackage ./update.nix {};

  meta = with lib; {
    description = "A simple and private notes app";
    longDescription = ''
      Standard Notes is a private notes app that features unmatched simplicity,
      end-to-end encryption, powerful extensions, and open-source applications.
    '';
    homepage = "https://standardnotes.org";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ mgregoire chuangzhu squalus ];
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    platforms = builtins.attrNames srcjson.deb;
    mainProgram = "standardnotes";
  };
}
