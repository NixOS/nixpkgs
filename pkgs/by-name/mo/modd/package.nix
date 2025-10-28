{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "modd";
  version = "unstable-2021-12-15";

  src = fetchFromGitHub {
    owner = "cortesi";
    repo = "modd";
    rev = "6083f9d1c171bd3292945672dab654a70d205945";
    sha256 = "sha256-KDZyOnytDLyybHTgU1v/NpiomeHXMIUHiQ+Xpmwyo0w=";
  };

  vendorHash = "sha256-O+hJRMSwV/9NHxbaLjloCWnfPugfRYaXNve098wjbqQ=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Flexible developer tool that runs processes and responds to filesystem changes";
    mainProgram = "modd";
    homepage = "https://github.com/cortesi/modd";
    license = licenses.mit;
    maintainers = [ ];
  };
}
