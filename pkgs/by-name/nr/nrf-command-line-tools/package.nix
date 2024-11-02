{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, udev
, libusb1
, segger-jlink
}:

let
  supported = {
    x86_64-linux = {
      name = "linux-amd64";
      hash = "sha256-zL9tXl2HsO8JZXEGsjg4+lDJJz30StOMH96rU7neDsg=";
    };
    aarch64-linux = {
      name = "linux-arm64";
      hash = "sha256-ACy3rXsvBZNVXdVkpP2AqrsoqKPliw6m9UUWrFOCBzs=";
    };
    armv7l-linux = {
      name = "linux-armhf";
      hash = "sha256-nD1pHL/SQqC7OlxuovWwvtnXKMmhfx5qFaF4ti8gh8g=";
    };
  };

  platform = supported.${stdenv.system} or (throw "unsupported platform ${stdenv.system}");

  version = "10.23.2";

  url = let
    versionWithDashes = builtins.replaceStrings ["."] ["-"] version;
  in "https://nsscprodmedia.blob.core.windows.net/prod/software-and-other-downloads/desktop-software/nrf-command-line-tools/sw/versions-${lib.versions.major version}-x-x/${versionWithDashes}/nrf-command-line-tools-${version}_${platform.name}.tar.gz";

in stdenv.mkDerivation {
  pname = "nrf-command-line-tools";
  inherit version;

  src = fetchurl {
    inherit url;
    inherit (platform) hash;
  };

  runtimeDependencies = [
    segger-jlink
  ];

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    udev
    libusb1
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    rm -rf ./python
    mkdir -p $out
    cp -r * $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "Nordic Semiconductor nRF Command Line Tools";
    homepage = "https://www.nordicsemi.com/Products/Development-tools/nRF-Command-Line-Tools";
    license = licenses.unfree;
    platforms = attrNames supported;
    maintainers = with maintainers; [ stargate01 ];
  };
}
