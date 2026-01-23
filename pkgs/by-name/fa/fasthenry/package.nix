{
  stdenv,
  fetchFromGitHub,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fasthenry";
  # later versions are Windows only ports
  # nixpkgs-update: no auto update
  version = "3.0.1";

  # we don't use the original MIT code at
  # https://www.rle.mit.edu/cpg/research_codes.htm
  # since the FastFieldSolvers S.R.L. version includes
  # a couple of bug fixes
  src = fetchFromGitHub {
    owner = "ediloren";
    repo = "FastHenry2";
    tag = "R${finalAttrs.version}";
    hash = "sha256-jM0mLVJRUmtHF9dcDJw81vkHpgqyz1RihB7+ZGJm8wQ=";
  };

  env.NIX_CFLAGS_COMPILE = toString [
    "-fcommon -O -DFOUR"
    (lib.optional stdenv.hostPlatform.isx86_64 "-m64")
    "-Wno-error=implicit-function-declaration"
    "-Wno-error=implicit-int"
    "-Wno-error=return-mismatch"
  ];

  makeFlags = [ "all" ]; # need "all" to be explicitely set

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r bin/* $out/bin/
    mkdir -p $out/share/fasthenry/doc
    cp -r doc/* $out/share/fasthenry/doc
    mkdir -p $out/share/fasthenry/examples
    cp -r examples/* $out/share/fasthenry/examples

    runHook postInstall
  '';

  meta = {
    description = "Multipole-accelerated inductance analysis program";
    longDescription = ''
      Fasthenry is an inductance extraction program based on a
      multipole-accelerated algorithm.'';
    homepage = "https://www.fastfieldsolvers.com/fasthenry2.htm";
    license = lib.licenses.lgpl2Only;
    maintainers = with lib.maintainers; [ fbeffa ];
    platforms = with lib.platforms; lib.intersectLists linux (x86_64 ++ x86);
    mainProgram = "fasthenry";
  };
})
