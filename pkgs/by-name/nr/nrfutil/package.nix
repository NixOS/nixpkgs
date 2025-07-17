{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  libusb1,
  segger-jlink-headless,
}:

let
  source = import ./source.nix;
  supported = removeAttrs source [ "version" ];

  platform = supported.${stdenvNoCC.system} or (throw "unsupported platform ${stdenvNoCC.system}");

in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "nrfutil";
  inherit (source) version;

  src = fetchurl {
    url = "https://files.nordicsemi.com/artifactory/swtools/external/nrfutil/packages/nrfutil/nrfutil-${platform.name}-${finalAttrs.version}.tar.gz";
    inherit (platform) hash;
  };

  nativeBuildInputs = [ makeWrapper ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv data/* $out/

    wrapProgram $out/bin/nrfutil \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          segger-jlink-headless
          libusb1
        ]
      }"

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "CLI tool for managing Nordic Semiconductor devices";
    homepage = "https://www.nordicsemi.com/Products/Development-tools/nRF-Util";
    changelog = "https://docs.nordicsemi.com/bundle/nrfutil/page/guides/revision_history.html";
    license = licenses.unfree;
    platforms = attrNames supported;
    maintainers = with maintainers; [ h7x4 ];
    mainProgram = "nrfutil";
  };
})
