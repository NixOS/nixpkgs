{
  stdenv,
  fetchFromGitHub,
  fetchzip,
  lib,
  cmake,
  nix-update-script,
  vst2-sdk,
}:
stdenv.mkDerivation {
  pname = "airwindows";
  version = "0-unstable-2025-03-02";

  src = fetchFromGitHub {
    owner = "airwindows";
    repo = "airwindows";
    rev = "f172389273a0ab35f703a6ab267c737d28ab7ec5";
    hash = "sha256-YmtH5KtPeTDR8imQkTriJx5sD9cS5Tqp6Yjri/I+q3Y=";
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
