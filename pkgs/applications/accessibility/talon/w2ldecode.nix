{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "w2ldecode";
  version = "unstable-2022-11-29";

  # kenlm = https://github.com/kpu/kenlm
  src = fetchFromGitHub {
    owner = "talonvoice";
    repo = "w2ldecode";
    rev = "194a0a97fdf8866d311bc43acc06c374a7050d9a";
    sha256 = "sha256-ecrW7zZOVbgjZ5xNl3ICiZDxMb6aAbJm59VTOKVmdV8=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    homepage = "https://github.com/talonvoice/w2ldecode";
    description = "wav2letter decoder";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ milahu ];
    platforms = lib.platforms.unix;
  };
}
