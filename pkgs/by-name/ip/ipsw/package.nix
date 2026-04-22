{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGo126Module,
}:

buildGo126Module (finalAttrs: {
  version = "3.1.671";
  pname = "ipsw";

  src = fetchFromGitHub {
    owner = "blacktop";
    repo = "ipsw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Grh0WeeslpebG+ryacUPXD3OPIbJtA1zDejothKmdxQ=";
  };

  vendorHash = "sha256-J4S5VsGZEeDdiNNl0LlqIPG53Vg0xKuW1wsmrULetgQ=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppVersion==${finalAttrs.version}"
    "-X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppBuildCommit==${finalAttrs.src.tag}"
  ];

  subPackages = [
    "cmd/ipsw"
  ];

  meta = {
    description = "iOS/macOS Research Swiss Army Knife";
    homepage = "https://blacktop.github.io/ipsw";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.viraptor ];
    platforms = lib.platforms.unix;
    mainProgram = "ipsw";
  };
})
