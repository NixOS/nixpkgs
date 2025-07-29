{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "murex";
  version = "7.0.2107";

  src = fetchFromGitHub {
    owner = "lmorg";
    repo = "murex";
    rev = "v${version}";
    sha256 = "sha256-k87Xj92TDPlcHNGSbAL1oznCX+0mVd5pHzZ/QiA4s2A=";
  };

  vendorHash = "sha256-p+KIaZLJEWxsOTRKhg0X3qpBdY3VBQUb8+A84A1eOdw=";

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
