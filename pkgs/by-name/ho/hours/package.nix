{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "hours";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "dhth";
    repo = "hours";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z1VHvzUQJoZeSuc1LpTw+z3XCFRJqNU+GIWwlAEXl1o=";
  };

  vendorHash = "sha256-Sim17RybSM92H6OP0Od9gH/wqa+5cd4Lmli6Na8RDJk=";

  doCheck = !stdenv.hostPlatform.isDarwin;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "No-frills time tracking toolkit for command line nerds";
    homepage = "https://github.com/dhth/hours";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ilarvne ];
    platforms = lib.platforms.unix;
    mainProgram = "hours";
  };
})
