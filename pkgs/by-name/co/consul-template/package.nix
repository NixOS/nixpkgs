{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "consul-template";
  version = "0.40.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "consul-template";
    rev = "v${version}";
    hash = "sha256-iqBcY7FYCO4qqQRAHxA2sxTnyL5c0vLVWKuhqvX0oJE=";
  };

  vendorHash = "sha256-Slp+x+cYYIC/XgICb9qDdqq1gTDxLNwXyClaWZt1fs8=";

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
