{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "murex";
  version = "7.4.2002";

  src = fetchFromGitHub {
    owner = "lmorg";
    repo = "murex";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-XH+6feN12QpyFVRnEy0WVnAqreBVTIcrMc7I3kfaazA=";
  };

  vendorHash = "sha256-YHGLx7OnEApfSpXP2aokJMWtGsSLsa0juvRRuG6lICg=";

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
