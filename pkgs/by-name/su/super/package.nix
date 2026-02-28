{
  buildGoModule,
  fetchFromGitHub,
  lib,
  runCommand,
  super,
}:
buildGoModule (finalAttrs: {
  pname = "super";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "brimdata";
    repo = "super";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MAlBVY2O9T1j+N/kSgEw3onnIicrhOoa2vqnGEiXCdg=";
  };

  vendorHash = "sha256-EkQatync50uz4dSVrX0lIAh4FaEMRR6UTsYZATi+kNw=";

  ldflags = [
    "-s"
    "-X"
    "github.com/brimdata/super/cli.version=${finalAttrs.version}"
  ];

  subPackages = [
    "cmd/super"
  ];

  passthru.tests = {
    hello-world = runCommand "${finalAttrs.pname}-test" { } ''
      echo \"'hello, world'\" | ${super}/bin/super -color=false -f=line - > $out
      [ "$(cat $out)" = 'hello, world' ]
    '';
  };

  meta = {
    changelog = "https://github.com/brimdata/super/releases/tag/v${finalAttrs.version}";
    description = "Analytics database that puts JSON and relational tables on equal footing";
    homepage = "https://superdb.org";
    license = lib.licenses.bsd3;
    mainProgram = "super";
    maintainers = with lib.maintainers; [ hythera ];
  };
})
