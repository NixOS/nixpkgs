{ lib, buildGoModule, fetchFromGitHub, go-bindata, lessc, nodePackages, stdenv }:

buildGoModule rec {
  pname = "writefreely";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "writeas";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qYceijC/u8G9vr7uhApWWyWD9P65pLJCTjePEvh+oXA=";
  };

  vendorSha256 = "sha256-CBPvtc3K9hr1oEmC+yUe3kPSWx20k6eMRqoxsf3NfCE=";

  writefreely-assets = stdenv.mkDerivation {
    pname = "writefreely-assets";
    inherit src version;

    nativeBuildInputs = [ lessc ];

    buildPhase = ''
      export NODE_PATH=${nodePackages.less-plugin-clean-css}/lib/node_modules
      (
        cd less
        make all
      )
    '';

    installPhase = ''
      mkdir $out
      cp -r templates pages static $out/
    '';
  };

  nativeBuildInputs = [ go-bindata ];

  preBuild = ''
    make assets
  '';

  postBuild = ''
    mkdir $out
    ln -s ${writefreely-assets}/templates ${writefreely-assets}/pages ${writefreely-assets}/static $out/
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
