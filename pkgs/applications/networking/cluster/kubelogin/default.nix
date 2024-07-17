{
  lib,
  fetchFromGitHub,
  buildGoModule,
  go,
}:

buildGoModule rec {
  pname = "kubelogin";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-DRXvnIOETNlZ50oa8PbLSwmq6VJJcerUe1Ir7s4/7Kw=";
  };

  vendorHash = "sha256-K/GfRJ0KbizsVmKa6V3/ZLDKivJttEsqA3Q84S0S4KI=";

  ldflags = [
    "-X main.version=${version}"
    "-X main.goVersion=${lib.getVersion go}"
  ];

  meta = with lib; {
    description = "Kubernetes credential plugin implementing Azure authentication";
    mainProgram = "kubelogin";
    inherit (src.meta) homepage;
    license = licenses.mit;
    maintainers = [ ];
  };
}
