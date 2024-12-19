{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ligolo-ng";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "tnpitsecurity";
    repo = "ligolo-ng";
    rev = "refs/tags/v${version}";
    hash = "sha256-rngV3/fziDaJoe5WJFR8gOVBhf6emAJL+UFRWKdOfh8=";
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
