{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "consul-template";
  version = "0.41.1";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "consul-template";
    rev = "v${version}";
    hash = "sha256-lQTI3eTKggzNnN0KCu+ZcdqtDT06OfyIWPQg2qfaxro=";
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
      pradeepchhetri
    ];
    mainProgram = "consul-template";
  };
}
