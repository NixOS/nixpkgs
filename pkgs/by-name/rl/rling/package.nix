{ lib
, stdenv
, fetchFromGitHub
, libgcc
, judy
}:

stdenv.mkDerivation rec {
  pname = "rling";
  version = "unstable-2023-09-02";

  src = fetchFromGitHub {
    owner = "Cynosureprime";
    repo = "rling";
    rev = "c477c373d16f9f31b3509555b64c2901099a6b13";
    hash = "sha256-7LAl+FwnKLVTcbalQ7hQbnOaB9imK9D9XQUe21R2UgE=";
  };

  buildInputs = [ libgcc judy ];

  buildPhase = ''
    make
    gcc -o dedupe dedupe.c -I${judy}/include -L${judy}/lib -lJudy
    gcc -o getpass getpass.c
    gcc -o rehex rehex.c
    gcc -o splitlen splitlen.c
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp rling $out/bin
    cp dedupe $out/bin
    cp getpass $out/bin
    cp rehex $out/bin
    cp splitlen $out/bin
  '';

  meta = with lib; {
    description = "RLI Next Gen, a faster multi-threaded, feature rich alternative to rli found in hashcat-utils";
    homepage = "https://github.com/Cynosureprime/rling";
    license = licenses.mit;
    maintainers = with maintainers; [ octodi ];
    mainProgram = "rling";
  };
}
