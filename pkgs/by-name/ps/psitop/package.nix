{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "psitop";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "jamespwilliams";
    repo = "psitop";
    rev = finalAttrs.version;
    hash = "sha256-TD+NTlfmBtz+m2w2FnTcUIJQakpvVBCK/MAHfCrOue4=";
  };

  vendorHash = "sha256-oLtKpBvTsM5TbzfWIDfqgb7DL5D3Mldu0oimVeiUeSc=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Top for /proc/pressure";
    homepage = "https://github.com/jamespwilliams/psitop";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "psitop";
  };
})
