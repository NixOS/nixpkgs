{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "murex";
  version = "7.1.4143";

  src = fetchFromGitHub {
    owner = "lmorg";
    repo = "murex";
    rev = "v${version}";
    sha256 = "sha256-wLEEyRnV0ERji+HPgtu6NgZSgKu0B6MErL+8KX1lUhw=";
  };

  vendorHash = "sha256-ttBC4ZSoOcfauSNo5WTt/Ln3dn94VvdhYEFCzAli0dU=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Bash-like shell and scripting environment with advanced features designed for safety and productivity";
    mainProgram = "murex";
    homepage = "https://murex.rocks";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [
      dit7ya
      kashw2
    ];
  };

  passthru = {
    shellPath = "/bin/murex";
  };
}
