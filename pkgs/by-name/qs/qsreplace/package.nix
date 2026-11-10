{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "qsreplace";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "tomnomnom";
    repo = "qsreplace";
    rev = "v${finalAttrs.version}";
    hash = "sha256-j9bqO2gp4RUxZHGBCIxI5nA3nD1dG4nCpJ1i4TM/fbo=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    homepage = "https://github.com/tomnomnom/qsreplace";
    description = "Accept URLs on stdin, replace all query string values with a user-supplied value";
    mainProgram = "qsreplace";
    maintainers = with lib.maintainers; [ averagebit ];
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    license = lib.licenses.mit;
  };
})
