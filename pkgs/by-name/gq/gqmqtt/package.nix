{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:

buildGoModule rec {
  pname = "gqmqtt";
  version = "0.2.0-alpha";

  src = fetchFromGitHub {
    owner = "klumw";
    repo = "gqmqtt";
    tag = "v${version}";
    hash = "sha256-4FV2Z3eow69v/Z6sfVfJew/N8ceiXX+JtvLidmiysPk=";
  };

  vendorHash = "sha256-4kT3dswD+Zlgal/kt3jOclDKkrBNXOZqvSPXg79TqX0=";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "GQ GMC-500+ USB serial to MQTT bridge";
    homepage = "https://github.com/klumw/gqmqtt";
    changelog = "https://github.com/klumw/gqmqtt/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "gqmqtt";
  };
}
