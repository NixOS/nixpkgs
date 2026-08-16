{
  buildGoModule,
  fetchFromGitHub,
  lib,
  runCommand,
  super,
}:
buildGoModule (finalAttrs: {
  pname = "super";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "brimdata";
    repo = "super";
    tag = "v${finalAttrs.version}";
    hash = "sha256-T/L5w15gZVTbs0jHTkHPnHwTJ2s+ILfouHyQMEXkq1M=";
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
    license = {
      free = false;
      fullName = "SuperDB Source Available License version 1.0";
      redistributable = true;
      url = "https://github.com/brimdata/super/blob/5baa422ab9791bfc1a7f778b2e4354885825adf8/LICENSE.md";
    };
    mainProgram = "super";
    maintainers = with lib.maintainers; [ hythera ];
  };
})
