{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "murex";
  version = "7.3.1231";

  src = fetchFromGitHub {
    owner = "lmorg";
    repo = "murex";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-HBJIPLqjtYmdkh2vONSlzfl4DfGrPkwDGsUwFvpPrRk=";
  };

  vendorHash = "sha256-NFujuX0lIse0DgcHl670CoPdpekKdjhJxwE8Jlb/atk=";

  subPackages = [ "." ];

  meta = {
    description = "Bash-like shell and scripting environment with advanced features designed for safety and productivity";
    mainProgram = "murex";
    homepage = "https://murex.rocks";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      kashw2
    ];
  };

  passthru = {
    shellPath = "/bin/murex";
  };
})
