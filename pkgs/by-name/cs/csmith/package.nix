{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  m4,
  makeWrapper,
  libbsd,
  perlPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "csmith";
  version = "2.3.0-unstable-2026-03-01";

  src = fetchFromGitHub {
    owner = "csmith-project";
    repo = "csmith";
    rev = "0cdc710315cfee9035e22ef4363ca479270d1934";
    hash = "sha256-m0xdGtccxGFMHFYRCultkEfMEs9ju8ccx7kZbxNTapE=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    m4
    makeWrapper
  ];
  buildInputs = [
    libbsd
  ]
  ++ (with perlPackages; [
    perl
    SysCPU
  ]);

  env.CXXFLAGS = "-std=c++98";

  postInstall = ''
    substituteInPlace $out/bin/compiler_test.pl \
      --replace-fail '$CSMITH_HOME/runtime' $out/include/csmith-${finalAttrs.version} \
      --replace-fail ' ''${CSMITH_HOME}/runtime' " $out/include/csmith-${finalAttrs.version}" \
      --replace-fail '$CSMITH_HOME/src/csmith' $out/bin/csmith

    substituteInPlace $out/bin/launchn.pl \
      --replace-fail '../compiler_test.pl' $out/bin/compiler_test.pl \
      --replace-fail '../$CONFIG_FILE' '$CONFIG_FILE'

    wrapProgram $out/bin/launchn.pl \
      --prefix PERL5LIB : "$PERL5LIB"

    mkdir -p $out/share/csmith
    mv $out/bin/compiler_test.in $out/share/csmith/
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Random generator of C programs";
    homepage = "https://embed.cs.utah.edu/csmith";
    # Officially, the license is this: https://github.com/csmith-project/csmith/blob/master/COPYING
    license = lib.licenses.bsd2;
    longDescription = ''
      Csmith is a tool that can generate random C programs that statically and
      dynamically conform to the C99 standard. It is useful for stress-testing
      compilers, static analyzers, and other tools that process C code.
      Csmith has found bugs in every tool that it has tested, and has been used
      to find and report more than 400 previously unknown compiler bugs.
    '';
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
