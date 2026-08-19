{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pingtcp";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "LanetNetwork";
    repo = "pingtcp";
    hash = "sha256-yGKW/3/smzVvdhkqzf0NWpcthfW9XzXQCnoAD4YlaLM=";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    # fix compatibility with CMake (https://cmake.org/cmake/help/v4.0/command/cmake_minimum_required.html)
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "4.0")
  ];

  doCheck = false;

  postInstall = ''
    install -Dm644 {..,$out/share/doc/pingtcp}/README.md
  '';

  meta = {
    description = "Measure TCP handshake time";
    homepage = "https://github.com/LanetNetwork/pingtcp";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    mainProgram = "pingtcp";
  };
})
