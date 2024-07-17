{
  lib,
  stdenv,
  fetchFromGitHub,
  readline,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "abc-verifier";
  version = "unstable-2023-10-13";

  src = fetchFromGitHub {
    owner = "yosyshq";
    repo = "abc";
    rev = "896e5e7dedf9b9b1459fa019f1fa8aa8101fdf43";
    hash = "sha256-ou+E2lvDEOxXRXNygE/TyVi7quqk+CJHRI+HDI0xljE=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ readline ];

  installPhase = ''
    runHook preInstall
    install -Dm755 'abc' "$out/bin/abc"
    runHook postInstall
  '';

  # needed by yosys
  passthru.rev = finalAttrs.src.rev;

  meta = with lib; {
    description = "A tool for squential logic synthesis and formal verification";
    homepage = "https://people.eecs.berkeley.edu/~alanmi/abc";
    license = licenses.mit;
    maintainers = with maintainers; [
      thoughtpolice
      Luflosi
    ];
    mainProgram = "abc";
    platforms = platforms.unix;
  };
})
