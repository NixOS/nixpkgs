{
  lib,
  buildGoModule,
  fetchFromGitHub,
  sqlite,
  libtensorflow,
  withTensorflow ? false,
  nixosTests,
}:
buildGoModule (finalAttrs: {
  pname = "snips-sh";
  version = "0.10.1";
  vendorHash = "sha256-OjcYz7RdCCWur8y+AhGVlQx3UeW+u6rmB73lDUYBsnM=";

  src = fetchFromGitHub {
    owner = "robherley";
    repo = "snips.sh";
    rev = "v${finalAttrs.version}";
    hash = "sha256-KPIit7U+630EQ8SeFArCR2qcXVdsjaO1LKZmDO86c0Y=";
  };

  tags = (lib.optional (!withTensorflow) "noguesser");

  buildInputs = [ sqlite ] ++ (lib.optional withTensorflow libtensorflow);

  passthru.tests = nixosTests.snips-sh;

  meta = {
    description = "Passwordless, anonymous SSH-powered pastebin with a human-friendly TUI and web UI";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    homepage = "https://snips.sh";
    maintainers = with lib.maintainers; [
      jeremiahs
      matthiasbeyer
    ];
    mainProgram = "snips.sh";
  };
})
