{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "todoist";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "sachaos";
    repo = "todoist";
    rev = "v${version}";
    sha256 = "sha256-cfhwbL7RaeD5LWxlfqnHfPPPkC5AA3Z034p+hlFBWtg=";
  };

  vendorSha256 = "sha256-ly+OcRo8tGeNX4FnqNVaqjPx/A1FALOnScxs04lIOiU=";

  doCheck = false;

  postPatch = ''
    substituteInPlace main.go --replace '0.15.0' '${version}'
  '';

  meta = {
    homepage = "https://github.com/sachaos/todoist";
    description = "Todoist CLI Client";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
