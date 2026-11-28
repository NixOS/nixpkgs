{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  gomarkdoc,
}:

buildGoModule (finalAttrs: {
  pname = "gomarkdoc";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "princjef";
    repo = "gomarkdoc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-eMH+F1ZXAKHqnrvOJvCETm2NiDwY03IFHrDNYr3jaW8=";
  };

  subPackages = [ "cmd/gomarkdoc" ];

  vendorHash = "sha256-gCuYqk9agH86wfGd7k6QwLUiG3Mv6TrEd9tdyj8AYPs=";

  # Go 1.26 resolves this field reference while generating the command golden.
  postPatch = ''
    substituteInPlace testData/docs/README.md \
      --replace-fail 'GetField gets \[\*AnotherStruct.Field\].' \
      'GetField gets [\\\*AnotherStruct.Field](<#AnotherStruct>).'
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.commit=${finalAttrs.src.rev}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = gomarkdoc;
    };
  };

  meta = {
    description = "Generate markdown documentation for Go (golang) code";
    homepage = "https://github.com/princjef/gomarkdoc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ brpaz ];
    mainProgram = "gomarkdoc";
  };
})
