{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "syncthing_exporter";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "f100024";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-C3YnGs7A19No7tY7tIilwKi55n4S8x5whfyiAqMxMj0=";
  };

  vendorSha256 = "sha256-JbrCgt5Tu65IZNqtz3OvIESwYO1p6cH1ohzkVc1pwTE=";

  postInstallCheck = ''
    $out/bin/syncthing_exporter --version > /dev/null
  '';

  meta = with lib; {
    description = "Syncthing metrics exporter for prometheus";
    homepage = "https://github.com/f100024/syncthing_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ payas ];
  };
}
