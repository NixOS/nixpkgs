{
  stdenv,
  fetchFromGitHub,
  lib,
  cmake,
  nix-update-script,
  vst2-sdk,
}:
stdenv.mkDerivation {
  pname = "airwindows";
  version = "0-unstable-2026-05-02";

  src = fetchFromGitHub {
    owner = "airwindows";
    repo = "airwindows";
    rev = "6df9b9832d0e4a1532040c0d4eba5b12bd795f79";
    hash = "sha256-MOGVRIxlxyJk4LCW5iVtukV4fAnVoc+wORw2REGRyPc=";
  };

  # we patch helpers because honestly im spooked out by where those variables
  # came from.
  prePatch = ''
    mkdir -p plugins/LinuxVST/include
    ln -s ${vst2-sdk} plugins/LinuxVST/include/vstsdk
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
    vst2-sdk
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
    ];
    maintainers = [ lib.maintainers.l1npengtul ];
  };
}
