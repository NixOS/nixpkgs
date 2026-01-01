{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "psitop";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "jamespwilliams";
    repo = "psitop";
    rev = version;
    hash = "sha256-TD+NTlfmBtz+m2w2FnTcUIJQakpvVBCK/MAHfCrOue4=";
  };

  vendorHash = "sha256-oLtKpBvTsM5TbzfWIDfqgb7DL5D3Mldu0oimVeiUeSc=";

  ldflags = [
    "-s"
    "-w"
  ];

<<<<<<< HEAD
  meta = {
    description = "Top for /proc/pressure";
    homepage = "https://github.com/jamespwilliams/psitop";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Top for /proc/pressure";
    homepage = "https://github.com/jamespwilliams/psitop";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
    mainProgram = "psitop";
  };
}
