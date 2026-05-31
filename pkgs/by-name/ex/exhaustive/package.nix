{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "exhaustive";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "nishanths";
    repo = "exhaustive";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OLIdtKzCqnBkzdUSIl+UlENeMl3zrBE47pLWPg+6qXw=";
  };

  vendorHash = "sha256-jTKzfQnqCN15EOzAWGTHtolWFNj/0g4ay0ckgoa2E34=";

  patches = [
    # https://github.com/nishanths/exhaustive/pull/85
    ./fix-go125.patch
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Check exhaustiveness of switch statements of enum-like constants in Go code";
    mainProgram = "exhaustive";
    homepage = "https://github.com/nishanths/exhaustive";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ meain ];
  };
})
