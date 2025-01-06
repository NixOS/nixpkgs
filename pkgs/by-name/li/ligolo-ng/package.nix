{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ligolo-ng";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "tnpitsecurity";
    repo = "ligolo-ng";
    tag = "v${version}";
    hash = "sha256-BU3gBUNOTjpAANkvzPcgsZrly+TkbG86LHtZf93uxeY=";
  };

  vendorHash = "sha256-v6lHY3s1TJh8u4JaTa9kcCj+1pl01zckvTVeLk8TZ+w=";

  postConfigure = ''
    export CGO_ENABLED=0
  '';

  ldflags = [
    "-s"
    "-w"
    "-extldflags '-static'"
  ];

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Tunneling/pivoting tool that uses a TUN interface";
    homepage = "https://github.com/tnpitsecurity/ligolo-ng";
    changelog = "https://github.com/nicocha30/ligolo-ng/releases/tag/v${version}";
    license = licenses.gpl3Only;
  };
}
