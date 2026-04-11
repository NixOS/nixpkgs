{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "murex";
  version = "7.2.1001";

  src = fetchFromGitHub {
    owner = "lmorg";
    repo = "murex";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Ua5KEtT1HXRCqW4MwB0dYCd03DBrliEfgiSmcp+vZS8=";
  };

  vendorHash = "sha256-MaBBi2Qi7s9lfRWmnYkyr7PtwzC7ZL0jmyUXzISOXVg=";

  subPackages = [ "." ];

  meta = {
    description = "Bash-like shell and scripting environment with advanced features designed for safety and productivity";
    mainProgram = "murex";
    homepage = "https://murex.rocks";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      dit7ya
      kashw2
    ];
  };

  passthru = {
    shellPath = "/bin/murex";
  };
})
