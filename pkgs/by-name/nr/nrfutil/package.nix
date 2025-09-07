{
  lib,
  stdenvNoCC,
  fetchurl,

  xz,
  zlib,
  libusb1,
  segger-jlink-headless,
  gcc,

  autoPatchelfHook,
  versionCheckHook,
  makeWrapper,

  symlinkJoin,
  extensions ? [ ],
  nrfutil,
}:

let
  sources = import ./source.nix;
  platformSources =
    sources.${stdenvNoCC.system} or (throw "unsupported platform ${stdenvNoCC.system}");

  sharedMeta = with lib; {
    description = "CLI tool for managing Nordic Semiconductor devices";
    homepage = "https://www.nordicsemi.com/Products/Development-tools/nRF-Util";
    changelog = "https://docs.nordicsemi.com/bundle/nrfutil/page/guides/revision_history.html";
    license = licenses.unfree;
    platforms = lib.attrNames sources;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [
      h7x4
      ezrizhu
    ];
  };

  packages = map (
    name:
    let
      package = platformSources.packages.${name};
    in
    stdenvNoCC.mkDerivation (finalAttrs: {
      pname = name;
      inherit (package) version;

      src = fetchurl {
        url = "https://files.nordicsemi.com/artifactory/swtools/external/nrfutil/packages/${name}/${name}-${platformSources.triplet}-${package.version}.tar.gz";
        inherit (package) hash;
      };

      nativeBuildInputs = [
        autoPatchelfHook
      ];

      buildInputs = [
        xz
        zlib
        libusb1
        gcc.cc.lib
        segger-jlink-headless
      ];

      dontConfigure = true;
      dontBuild = true;

      installPhase = ''
        runHook preInstall

        mkdir -p $out
        mv data/* $out/

        runHook postInstall
      '';

      doInstallCheck = true;
      nativeInstallCheckInputs = [
        versionCheckHook
      ];
      versionCheckProgramArg = "--version";

      meta = sharedMeta // {
        mainProgram = name;
      };
    })
  ) ([ "nrfutil" ] ++ extensions);

in
symlinkJoin {
  pname = "nrfutil";
  inherit (platformSources.packages.nrfutil) version;

  paths = packages;

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/nrfutil \
      --prefix PATH ":" "$out/bin" \
      --set NRF_JLINK_DLL_PATH "${segger-jlink-headless}/lib/libjlinkarm.so"
  '';

  passthru = {
    updateScript = ./update.sh;
    withExtensions = extensions: nrfutil.override { inherit extensions; };
  };

  meta = sharedMeta // {
    mainProgram = "nrfutil";
  };
}
