{
  lib,
  stdenv,
  fetchFromGitHub,
  readline,
  autoreconfHook,
  autoconf-archive,
  gcc,
  gmp,
  flex,
  bison,
  libffi,
  makeWrapper,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "bic";
  version = "1.0.0-unstable-2022-02-16";

  src = fetchFromGitHub {
    owner = "hexagonal-sun";
    repo = "bic";
    rev = "b224d2776fdfe84d02eb96a21880a9e4ceeb3065";
    hash = "sha256-6na7/kCXhHN7utbvXvTWr3QG4YhDww9AkilyKf71HlM=";
  };

  buildInputs = [
    readline
    gcc
    gmp
  ];

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    bison
    flex
    gcc
    libffi
    makeWrapper
    pkg-config
  ];

  postInstall = ''
    wrapProgram $out/bin/bic \
      --prefix PATH : ${lib.makeBinPath [ gcc ]}
  '';

  meta = {
    description = "C interpreter and API explorer";
    mainProgram = "bic";
    longDescription = ''
      bic This a project that allows developers to explore and test C-APIs using a
      read eval print loop, also known as a REPL.
    '';
    license = with lib.licenses; [ gpl2Plus ];
    homepage = "https://github.com/hexagonal-sun/bic";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ hexagonal-sun ];
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64;
  };
}
