{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "murex";
  version = "7.3.1232";

  src = fetchFromGitHub {
    owner = "lmorg";
    repo = "murex";
    rev = "v${finalAttrs.version}";
    hash = "sha256-eehiXcUJNc/5FTjsIiJSW/r1hSHdqUFBAf4kEOQgKig=";
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
