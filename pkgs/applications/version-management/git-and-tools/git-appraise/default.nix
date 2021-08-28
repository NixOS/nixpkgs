{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "git-appraise-unstable";
  version = "2018-02-26";
  rev = "2414523905939525559e4b2498c5597f86193b61";

  goPackagePath = "github.com/google/git-appraise";

  src = fetchFromGitHub {
    inherit rev;
    owner = "google";
    repo = "git-appraise";
    sha256 = "04xkp1jpas1dfms6i9j09bgkydih0q10nhwn75w9ds8hi2qaa3sa";
  };

  meta = {
    description = "Distributed code review system for Git repos";
    homepage = "https://github.com/google/git-appraise";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.vdemeester ];
  };
}
