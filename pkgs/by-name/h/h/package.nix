{
  lib,
  stdenv,
  fetchFromGitHub,
  ruby,
}:

stdenv.mkDerivation rec {
  pname = "h";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "zimbatm";
    repo = "h";
    rev = "v${version}";
    hash = "sha256-Iv+BqM6AF7wD5yyFSvA5pkG2yfQrNp6aBFV1OCUom5c=";
  };

  buildInputs = [ ruby ];

  installPhase = ''
    mkdir -p $out/bin
    cp h $out/bin/h
    cp up $out/bin/up
  '';

  meta = with lib; {
    description = "Faster shell navigation of projects";
    homepage = "https://github.com/zimbatm/h";
    license = licenses.mit;
    maintainers = [ maintainers.zimbatm ];
  };
}
