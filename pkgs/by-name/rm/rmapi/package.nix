{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "rmapi";
  version = "0.0.27.1";

  src = fetchFromGitHub {
    owner = "ddvk";
    repo = "rmapi";
    rev = "v${version}";
    sha256 = "sha256-nwGTBCzA9+J3S3Gd3YgwCWAj/gMcoS19awluDZWZCbU=";
  };

  vendorHash = "sha256-5m3/XFyBEWM8UB3WylkBj+QWI5XsnlVD4K3BhKVVCB4=";

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
