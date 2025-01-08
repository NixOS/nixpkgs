{
  lib,
  stdenv,
  fetchFromGitLab,
  libpcap,
}:

stdenv.mkDerivation rec {
  pname = "pcapc";
  version = "1.0.1";

  src = fetchFromGitLab {
    owner = "post-factum";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-oDg9OSvi9aQsZ2SQm02NKAcppE0w5SGZaI13gdp7gv4=";
  };

  buildInputs = [ libpcap ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    homepage = "https://gitlab.com/post-factum/pcapc";
    description = "Compile libpcap filter expressions into BPF opcodes";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    mainProgram = "pcapc";
  };
}
