{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "exhaustive";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "nishanths";
    repo = "exhaustive";
    rev = "v${finalAttrs.version}";
    hash = "sha256-fjvr4eCXnDrePqSZ30FzkR8fOatev2J54t6b936+O54=";
  };

  vendorHash = "sha256-RSM6tV5mMwL69bsC/vlP8iq2AR71pkY6MjBcUnAYW8I=";

  # Script tests expect the binary next to them, and -mod=vendor from GOFLAGS
  # breaks the testdata modules, which have no vendor directories.
  preCheck = ''
    ln -s $GOPATH/bin/exhaustive cmd/exhaustive/exhaustive-scripttest
    export GOFLAGS="''${GOFLAGS//-mod=vendor/}"
  '';

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
