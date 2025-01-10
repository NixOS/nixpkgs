{
  lib,
  rustPlatform,
  fetchFromGitHub,
  llvm_16,
  libffi,
  libz,
  libxml2,
  ncurses,
  stdenv,
  makeWrapper,
  callPackage,
}:

rustPlatform.buildRustPackage rec {
  pname = "inko";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "inko-lang";
    repo = "inko";
    rev = "v${version}";
    hash = "sha256-Iojv8pTyILYpLFnoTlgUGmlfWWH0DgsGBRxzd3oRNwA=";
  };

  cargoHash = "sha256-PaZD7wwcami6EWvOHLislNkwQhCZItN9XZkPSExwo0U=";

  buildInputs = [
    libffi
    libz
    libxml2
    ncurses
    (lib.getLib stdenv.cc.cc)
  ];

  nativeBuildInputs = [
    llvm_16
    makeWrapper
  ];

  env = {
    INKO_STD = "${placeholder "out"}/lib";
    INKO_RT = "${placeholder "out"}/lib/runtime";
  };

  postFixup = ''
    wrapProgram $out/bin/inko \
      --prefix PATH : ${lib.makeBinPath [ stdenv.cc ]}
  '';

  postInstall = ''
    mkdir -p $out/lib/runtime
    mv $out/lib/*.a $out/lib/runtime/
    cp -r std/src/* $out/lib/
  '';

  passthru.tests = {
    simple = callPackage ./test.nix { };
  };

  meta = {
    description = "Language for building concurrent software with confidence";
    homepage = "https://inko-lang.org/";
    license = lib.licenses.mpl20;
    maintainers = [ lib.maintainers.feathecutie ];
    platforms = lib.platforms.unix;
    mainProgram = "inko";
  };
}
