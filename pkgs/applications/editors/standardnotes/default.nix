{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  makeWrapper,
  electron,
  libsecret,
  asar,
  python3,
  glib,
  desktop-file-utils,
  callPackage,
}:

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

  nativeBuildInputs = [
    makeWrapper
    dpkg
    desktop-file-utils
    asar
  ];

  installPhase =
    let
      libPath = lib.makeLibraryPath [
        libsecret
        glib
        (lib.getLib stdenv.cc.cc)
      ];
    in
    ''
      runHook preInstall

      mkdir -p $out/bin $out/share/standardnotes
      cp -R usr/share/{applications,icons} $out/share
      cp -R opt/Standard\ Notes/resources/app.asar $out/share/standardnotes/
      cp -R opt/Standard\ Notes/resources/app.asar.unpacked $out/share/standardnotes/
      rm $out/share/standardnotes/app.asar.unpacked/node_modules/cbor-extract/build/node_gyp_bins/python3
      ln -s ${python3.interpreter} $out/share/standardnotes/app.asar.unpacked/node_modules/cbor-extract/build/node_gyp_bins/python3
      ${lib.optionalString stdenv.hostPlatform.isAarch64 ''
        rm $out/share/standardnotes/app.asar.unpacked/node_modules/microtime/build/node_gyp_bins/python3
        ln -s ${python3.interpreter} $out/share/standardnotes/app.asar.unpacked/node_modules/microtime/build/node_gyp_bins/python3
      ''}
      asar e $out/share/standardnotes/app.asar asar-unpacked
      find asar-unpacked -name '*.node' -exec patchelf \
        --add-rpath "${libPath}" \
        {} \;
      asar p asar-unpacked $out/share/standardnotes/app.asar

      makeWrapper ${electron}/bin/electron $out/bin/standardnotes \
        --add-flags $out/share/standardnotes/app.asar

      ${desktop-file-utils}/bin/desktop-file-install --dir $out/share/applications \
        --set-key Exec --set-value standardnotes usr/share/applications/standard-notes.desktop

      runHook postInstall
    '';

  passthru.updateScript = callPackage ./update.nix { };

  meta = with lib; {
    description = "Simple and private notes app";
    longDescription = ''
      Standard Notes is a private notes app that features unmatched simplicity,
      end-to-end encryption, powerful extensions, and open-source applications.
    '';
    homepage = "https://standardnotes.org";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
      mgregoire
      chuangzhu
      squalus
    ];
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    platforms = builtins.attrNames srcjson.deb;
    mainProgram = "standardnotes";
  };
}
