{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "consul-template";
  version = "0.41.3";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "consul-template";
    rev = "v${version}";
    hash = "sha256-v598V/pWZupZ6LKTYrJ0ES3Bs6TR5oAX5q2mnLbff+8=";
  };

  vendorHash = "sha256-Tz80n37NBqKX+h3OE6RBufPQ7OteWpZaa5br2WFIvOs=";

  # consul-template tests depend on vault and consul services running to
  # execute tests so we skip them here
  doCheck = false;

  passthru.tests = {
    inherit (nixosTests) consul-template;
  };

  meta = with lib; {
    homepage = "https://github.com/hashicorp/consul-template/";
    description = "Generic template rendering and notifications with Consul";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mpl20;
    maintainers = with maintainers; [
      cpcloud
    ];
    mainProgram = "consul-template";
  };
}
