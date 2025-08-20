{
  lib,
  stdenv,
  fetchFromGitHub,
  libbsd,
}:

stdenv.mkDerivation {
  pname = "sha2wordlist";
  version = "unstable-2023-02-20";

  src = fetchFromGitHub {
    owner = "kirei";
    repo = "sha2wordlist";
    rev = "2017b7ac786cfb5ad7f35f3f9068333b426d65f7";
    hash = "sha256-A5KIXvwllzUcUm52lhw0QDjhEkCVTcbLQGFZWmHrFpU=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace "gcc" "$CC"
  '';

  buildInputs = [
    libbsd
  ];

  installPhase = ''
    mkdir -p $out/bin
    install -m 755 sha2wordlist $out/bin
  '';

  meta = with lib; {
    description = "Display SHA-256 as PGP words";
    homepage = "https://github.com/kirei/sha2wordlist";
    maintainers = with maintainers; [ baloo ];
    license = [ licenses.bsd2 ];
    platforms = platforms.all;
    mainProgram = "sha2wordlist";
  };
}
