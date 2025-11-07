{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "rmapi";
  version = "0.0.31";

  src = fetchFromGitHub {
    owner = "ddvk";
    repo = "rmapi";
    rev = "v${version}";
    sha256 = "sha256-8OzDXOyyz0VTeJg0P6jOBTA9OZbCLSK8SASSEHsrBxc=";
  };

  vendorHash = "sha256-Qisfw+lCFZns13jRe9NskCaCKVj5bV1CV8WPpGBhKFc=";

  doCheck = false;

  meta = {
    description = "Go app that allows access to the ReMarkable Cloud API programmatically";
    homepage = "https://github.com/ddvk/rmapi";
    changelog = "https://github.com/ddvk/rmapi/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.nickhu ];
    mainProgram = "rmapi";
  };
}
