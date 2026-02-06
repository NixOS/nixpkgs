{
  lib,
  stdenv,
  fetchFromGitHub,
  readline,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "abc-verifier";
  version = "0.61";

  src = fetchFromGitHub {
    owner = "yosyshq";
    repo = "abc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-j/JmEJa29mT/XQmVL/adVbj4S+AAgpga1jbEinCN16w=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ readline ];

  cmakeFlags = [
    # This prevents CMake from trying to download googletest during the build
    (lib.cmakeBool "ABC_SKIP_TESTS" true)
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 'abc' "$out/bin/abc"
    runHook postInstall
  '';

  # needed by yosys
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
