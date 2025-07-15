{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "crcpp";
  version = "1.2.0.0";

  src = fetchFromGitHub {
    owner = "d-bahr";
    repo = "CRCpp";
    rev = "release-${version}";
    sha256 = "sha256-OY8MF8fwr6k+ZSA/p1U+9GnTFoMSnUZxKVez+mda2tA=";
  };

  nativeBuildInputs = [ cmake ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/d-bahr/CRCpp";
    changelog = "https://github.com/d-bahr/CRCpp/releases/tag/release-${version}";
    description = "Easy to use and fast C++ CRC library";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ];
    license = lib.licenses.bsd3;
  };
}
