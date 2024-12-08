{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "rmapi";
  version = "0.0.28";

  src = fetchFromGitHub {
    owner = "ddvk";
    repo = "rmapi";
    rev = "v${version}";
    sha256 = "sha256-/eiW0i7+FLa8i9a2RFcABVSC40MUwhsV+bHVLdPpV3s=";
  };

  vendorHash = "sha256-Qisfw+lCFZns13jRe9NskCaCKVj5bV1CV8WPpGBhKFc=";

  doCheck = false;

  meta = with lib; {
    description = "Go app that allows access to the ReMarkable Cloud API programmatically";
    homepage = "https://github.com/ddvk/rmapi";
    changelog = "https://github.com/ddvk/rmapi/blob/v${version}/CHANGELOG.md";
    license = licenses.agpl3Only;
    maintainers = [ maintainers.nickhu ];
    mainProgram = "rmapi";
  };
}
