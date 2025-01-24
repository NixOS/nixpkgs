{
  stdenv,
  fetchFromGitHub,
  fetchzip,
  lib,
  cmake,
  nix-update-script,
}:
let
  # adapted from oxefmsynth
  vst-sdk = stdenv.mkDerivation {
    dontConfigure = true;
    dontPatch = true;
    dontBuild = true;
    dontStrip = true;
    dontPatchELF = true;

    name = "vstsdk3610_11_06_2018_build_37";
    src = fetchzip {
      url = "https://web.archive.org/web/20181016150224if_/https://download.steinberg.net/sdk_downloads/vstsdk3610_11_06_2018_build_37.zip";
      sha256 = "0da16iwac590wphz2sm5afrfj42jrsnkr1bxcy93lj7a369ildkj";
    };

    installPhase = ''
      cp -r VST2_SDK $out
    '';
  };
in
stdenv.mkDerivation {
  pname = "airwindows";
  version = "0-unstable-2025-01-06";

  src = fetchFromGitHub {
    owner = "airwindows";
    repo = "airwindows";
    rev = "0ca33035253b9fc0c6c876592d9e5ff3a654cd10";
    hash = "sha256-+AyB6y179BRWTvflA9Ld5utpF2scSJDszkGa8BCvPdM=";
  };

  # we patch helpers because honestly im spooked out by where those variables
  # came from.
  prePatch = ''
    mkdir -p plugins/LinuxVST/include
    ln -s ${vst-sdk.out} plugins/LinuxVST/include/vstsdk
  '';

  patches = [
    ./cmakelists-and-helper.patch
  ];

  # we are building for linux, so we go to linux
  preConfigure = ''
    cd plugins/LinuxVST
  '';

  cmakeBuildType = "Release";

  cmakeFlags = [ ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    vst-sdk
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/vst/airwindows
    find "$PWD" -type f -name "*.so" -exec install -Dm755 {} $out/lib/vst/airwindows \;

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "All Airwindows VST Plugins";
    homepage = "https://airwindows.com/";
    platforms = lib.platforms.linux;
    license = [
      lib.licenses.mit
      lib.licenses.unfree
    ];
    maintainers = [ lib.maintainers.l1npengtul ];
  };
}
