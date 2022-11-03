{ lib, buildGoModule, fetchFromGitHub, go-bindata, updateGolangSysHook }:

buildGoModule rec {
  pname = "writefreely";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "writeas";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qYceijC/u8G9vr7uhApWWyWD9P65pLJCTjePEvh+oXA=";
  };

  vendorSha256 = "sha256-l65JlC+eUaabU5oSaWjqAARjdE0CfIcM/YERX8+5zO4=";

  nativeBuildInputs = [ go-bindata updateGolangSysHook ];

  preBuild = ''
    make assets
  '';

  ldflags = [ "-s" "-w" "-X github.com/writeas/writefreely.softwareVer=${version}" ];

  tags = [ "sqlite" ];

  subPackages = [ "cmd/writefreely" ];

  meta = with lib; {
    description = "Build a digital writing community";
    homepage = "https://github.com/writeas/writefreely";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
