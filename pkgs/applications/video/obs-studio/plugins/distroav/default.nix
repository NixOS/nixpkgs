{
  lib,
  stdenv,
  fetchFromGitHub,
  obs-studio,
  cmake,
  qtbase,
  ndi-6,
  curl,
}:

stdenv.mkDerivation rec {
  pname = "distroav";
  version = "6.1.1";

  nativeBuildInputs = [
    cmake
    qtbase
  ];

  buildInputs = [
    obs-studio
    qtbase
    ndi-6
    curl
  ];

  src = fetchFromGitHub {
    owner = "DistroAV";
    repo = "DistroAV";
    tag = version;
    hash = "sha256-nbXh6bjpiKbvuntZSnuTWWpmhfAcep7Krjjq8FvbENk=";
  };

  # Modify plugin-main.cpp file to fix ndi libs path
  patches = [ ./hardcode-ndi-path.patch ];

  postPatch = ''
    # Add path (variable added in hardcode-ndi-path.patch
    substituteInPlace src/plugin-main.cpp --replace-fail "@NDI@" "${ndi-6}"

    # Replace bundled NDI SDK with the upstream version
    # (This fixes soname issues)
    rm -rf lib/ndi
    ln -s ${ndi-6}/include lib/ndi
  '';

  cmakeFlags = [ "-DENABLE_QT=ON" ];

  env.NIX_CFLAGS_COMPILE = "-Wno-deprecated-declarations";

  dontWrapQtApps = true;

  meta = {
    description = "Network A/V plugin for OBS Studio (formerly obs-ndi)";
    homepage = "https://github.com/DistroAV/DistroAV";
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ globule655 ];
    platforms = lib.platforms.linux;
  };
}
