{ lib, buildGoModule, fetchgit }:

buildGoModule rec {
  pname = "clilol";
  version = "1.0.4";

  src = fetchgit {
    url = "https://git.mcornick.dev/mcornick/clilol.git";
    rev = "v${version}";
    hash = "sha256-VlL5prd021JrOf33jUdqORk9MxpyRQHNMpqDoSLLYi8=";
  };

  vendorHash = "sha256-i4UG52Z1zTM4VHBaNf5IYfQKnpC5iZTkK6L5hyQ6f4s=";

  # attempts to make calls to api.omg.lol
  doCheck = false;

  ldflags = [
    "-X git.mcornick.dev/mcornick/clilol/cmd.version=${version}"
  ];

  meta = with lib; {
    description = "CLI for omg.lol";
    homepage = "https://mcornick.dev/clilol/";
    changelog = "https://git.mcornick.dev/mcornick/clilol/releases/tag/${version}";
    license = licenses.mpl20;
    maintainers = [ maintainers.qbit ];
  };
}
