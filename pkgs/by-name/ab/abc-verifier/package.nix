{
  lib,
  stdenv,
  fetchFromGitHub,
  readline,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "abc-verifier";
  version = "0.55";

  src = fetchFromGitHub {
    owner = "yosyshq";
    repo = "abc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Ib6bZSPQmpI1UOsUG733TH6W6v+UnLyagdjUc8MreKw=";
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

  meta = {
    description = "Tool for squential logic synthesis and formal verification";
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
