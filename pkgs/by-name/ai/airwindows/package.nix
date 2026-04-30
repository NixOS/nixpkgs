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
  version = "0-unstable-2026-04-24";

  src = fetchFromGitHub {
    owner = "airwindows";
    repo = "airwindows";
    rev = "38f93aaaa74c0319b47ec4b9fc7f311fad86c86d";
    hash = "sha256-GxFhcMuJ2et+AFHtEdbwr8+sFRBy6/in5yXqxgd+wJw=";
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
