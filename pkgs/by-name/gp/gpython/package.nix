{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  gpython,
}:

buildGoModule (finalAttrs: {
  pname = "gpython";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "go-python";
    repo = "gpython";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xqwq27u41Jgoh7t9UDyatuBQswr+h3xio5AV/npncHc=";
  };

  vendorHash = "sha256-NXPllEhootdB8m5Wvfy8MW899oQnjWAQj7yCC2oDvqE=";

  subPackages = [
    "."
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=${finalAttrs.src.rev}"
    "-X=main.date=1970-01-01"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = gpython;
      command = "gpython < /dev/null";
    };
  };

  meta = {
    description = "Python interpreter written in Go";
    mainProgram = "gpython";
    homepage = "https://github.com/go-python/gpython";
    changelog = "https://github.com/go-python/gpython/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
