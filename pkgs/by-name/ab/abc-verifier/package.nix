{
  lib,
  stdenv,
  fetchFromGitHub,
  readline,
  gtest,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "abc-verifier";
  version = "0.64";

  src = fetchFromGitHub {
    owner = "yosyshq";
    repo = "abc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-T6Hj8zrr3XuI3Eh0I5rJI3+DAsuQIMtWEsaBJ8a5Cag=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ readline ];

  doCheck = true;
  checkInputs = [ gtest ];

  # thank you to the Arch Linux developers
  patches = [ ./cmake.patch ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
  ]
  # ABC CMake switches on definition not value
  ++ lib.optional (!finalAttrs.doCheck) (lib.cmakeBool "ABC_SKIP_TESTS" true);

  installPhase = ''
    runHook preInstall
    cmake --install .
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
