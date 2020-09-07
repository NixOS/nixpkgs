{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "git-subtrac";
  version = "0.04";

  src = fetchFromGitHub {
    owner = "apenwarr";
    repo = pname;
    rev = "v${version}";
    sha256 = "0p1n29k2a2rpznwxlwzkmx38ic6g041k9vx7msvick7cydn417fx";
  };

  vendorSha256 = "0m64grnmhjvfsw7a56474s894sgd24rvcp5kamhzzyc4q556hqny";

  doCheck = false;

  meta = with lib; {
    description = "Keep the content for your git submodules all in one place: the parent repo";
    homepage = "https://github.com/apenwarr/git-subtrac";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
