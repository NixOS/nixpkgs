{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage {
  pname = "git-codereview";
  version = "2020-01-15";
  goPackagePath = "golang.org/x/review";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "review";
    rev = "f51a73253c4da005cfdf18a036e11185c04c8ce3";
    sha256 = "0c4vsyy5zp7pngqn4q87xipndghxyw2x57dkv1kxnrffckx1s3pc";
  };

  meta = with lib; {
    description = "Manage the code review process for Git changes using a Gerrit server";
    homepage = "https://golang.org/x/review/git-codereview";
    license = licenses.bsd3;
    maintainers = [ maintainers.edef ];
  };
}
