{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGo126Module,
}:

buildGo126Module (finalAttrs: {
  version = "3.1.673";
  pname = "ipsw";

  src = fetchFromGitHub {
    owner = "blacktop";
    repo = "ipsw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oK1pEqYTA+XQObjuf9QSvXOXFR3iQH6ZwvpD0M/IIJY=";
  };

  vendorHash = "sha256-PELTN64zUUEQ3JhICRPWxAEM8j321T2h3q3lXb5qRQc=";

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
