{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "quicktemplate";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "valyala";
    repo = "quicktemplate";
    rev = "v${version}";
    sha256 = "cra3LZ3Yq0KNQErQ2q0bVSy7rOLKdSkIryIgQsNRBHw=";
  };

  vendorHash = null;

  meta = with lib; {
    homepage = "https://github.com/valyala/quicktemplate";
    description = "Fast, powerful, yet easy to use template engine for Go";
    license = licenses.mit;
    mainProgram = "qtc";
  };
}
