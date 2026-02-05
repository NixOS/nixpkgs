{
  lib,
  stdenv,
  fetchFromGitHub,
  readline,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "abc-verifier";
  version = "0.62";

  src = fetchFromGitHub {
    owner = "yosyshq";
    repo = "abc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-T6Hj8zrr3XuI3Eh0I5rJI3+DAsuQIMtWEsaBJ8a5Cag=";
  };

  buildInputs = [ readline ];

  # Defining the namespace is still required for OpenROAD
  env.NIX_CFLAGS_COMPILE = "-DABC_NAMESPACE=abc";

  makeFlags = [
    "ABC_USE_LIBSTDCXX=1"
    "ABC_USE_NAMESPACE=abc"
    "CC=${stdenv.cc.targetPrefix}gcc"
    "CXX=${stdenv.cc.targetPrefix}g++"
  ];

  buildPhase = ''
    runHook preBuild
    # Build both the 'abc' executable and the 'libabc.a' static library
    make -j$NIX_BUILD_CORES $makeFlags abc libabc.a
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 abc $out/bin/abc
    install -Dm644 libabc.a $out/lib/libabc.a

    pushd src
    find . -name "*.h" -exec install -Dm644 {} $out/include/{} \;
    popd
    runHook postInstall
  '';

  passthru.rev = finalAttrs.src.rev;

  meta = {
    description = "Tool for sequential logic synthesis and formal verification";
    homepage = "https://people.eecs.berkeley.edu/~alanmi/abc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      thoughtpolice
      Luflosi
    ];

    mainProgram = "abc";
    platforms = lib.platforms.unix;
  };
})
