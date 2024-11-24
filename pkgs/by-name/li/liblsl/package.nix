{
  cmake,
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "liblsl";
  version = "1.16.2";

  src = fetchFromGitHub {
    owner = "sccn";
    repo = "liblsl";
    rev = "v${version}";
    sha256 = "sha256-nmu7Kxk4U5sGO8Od9JR4id4V4mjeibj4AHjUYhpGPeo=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DLSL_UNIXFOLDERS=ON" ];

  meta = {
    description = "C++ lsl library for multi-modal time-synched data transmission over the local network";
    homepage = "https://github.com/sccn/liblsl";
    changelog = "https://github.com/sccn/liblsl/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ abcsds ];
    mainProgram = "liblsl";
    platforms = lib.platforms.all;
  };
}
