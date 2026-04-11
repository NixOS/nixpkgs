{ buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "openapi-mock";
  version = "0.3.9";

  src = fetchFromGitHub {
    owner = "muonsoft";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7u//uwcVV1/EI6Rr3ju7KOwMYt/dXivyvBWIpTaoWZk=";
  };

  vendorHash = "sha256-KPCRunuCIbBX+YpHgshixmrxM3Ey0LIdEC0Z4CtpQoI=";

  __structuredAttrs = true;
}
