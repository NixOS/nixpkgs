{
  stdenv,
  lib,
  fetchurl,
  symlinkJoin,
  withReadline ? true,
  readline,
}:

let
  readline-all = symlinkJoin {
    name = "readline-all";
    paths = [
      readline
      readline.dev
    ];
  };
in
stdenv.mkDerivation rec {
  pname = "oils-for-unix";
  version = "0.26.0";

  src = fetchurl {
    url = "https://www.oils.pub/download/oils-for-unix-${version}.tar.gz";
    hash = "sha256-K1spWld6J2OBQgO0o0iAygMGeinuuAr0hXtgkjFNbu0=";
  };

  postPatch = ''
    patchShebangs _build
  '';

  preInstall = ''
    mkdir -p $out/bin
  '';

  buildPhase = ''
    runHook preBuild

    _build/oils.sh

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ./install

    runHook postInstall
  '';

  strictDeps = true;
  buildInputs = lib.optional withReadline readline;
  # As of 0.19.0 the build generates an error on MacOS (using clang version 16.0.6 in the builder),
  # whereas running it outside of Nix with clang version 15.0.0 generates just a warning. The shell seems to
  # work just fine though, so we disable the error here.
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=incompatible-function-pointer-types";
  configureFlags =
    [
      "--datarootdir=${placeholder "out"}"
    ]
    ++ lib.optionals withReadline [
      "--with-readline"
      "--readline=${readline-all}"
    ];

  meta = {
    description = "Unix shell with JSON-compatible structured data. It's our upgrade path from bash to a better language and runtime";
    homepage = "https://www.oils.pub/";

    license = lib.licenses.asl20;

    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      mkg20001
      melkor333
    ];
    changelog = "https://www.oils.pub/release/${version}/changelog.html";
  };

  passthru = {
    shellPath = "/bin/osh";
  };
}
