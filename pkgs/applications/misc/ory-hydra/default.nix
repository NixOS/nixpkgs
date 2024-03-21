{ fetchFromGitHub, buildGoModule, lib, stdenv }:

buildGoModule rec {
  pname = "ory-hydra";
  version = "1.10.7";

  src = fetchFromGitHub {
    owner = "ory";
    repo = "hydra";
    rev = "v${version}";
    sha256 = "sha256-/cuzMTOMtju24tRO8KtW8yzztYFj9dSZRnYOMyAVMsk=";
  };

  vendorSha256 = "sha256-H3lAjlDpEcdQlFc5mwHOHhPjTSltUEleKIyZwUcXmtI=";

  subPackages = [ "." ];

  preBuild = ''
    # patchShebangs doesn't work for this Makefile, do it manually
    substituteInPlace Makefile --replace '/bin/bash' '${stdenv.shell}'
  '';

  meta = with lib; {
    maintainers = with maintainers; [ cmcdragonkai StillerHarpo ];
    homepage = "https://www.ory.sh/hydra/";
    license = licenses.asl20;
    description = "OpenID Certified OAuth 2.0 Server and OpenID Connect Provider optimized for low-latency, high throughput, and low resource consumption";
  };
}
