{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "chisel";
  version = "1.11.3";

  src = fetchFromGitHub {
    owner = "jpillora";
    repo = "chisel";
    tag = "v${version}";
    hash = "sha256-JrDRcp0gImG/5b/BC0KWM2IqJrS2mzO+ZX6kbTtQYlM=";
  };

  vendorHash = "sha256-2H+YHqYE1xm+7qDG3jfFpwS9FbYkbwJ6uso2At2BZcU=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/jpillora/chisel/share.BuildVersion=${version}"
  ];

  # Tests require access to the network
  doCheck = false;

  meta = {
    description = "TCP/UDP tunnel over HTTP";
    longDescription = ''
      Chisel is a fast TCP/UDP tunnel, transported over HTTP, secured via
      SSH. Single executable including both client and server. Chisel is
      mainly useful for passing through firewalls, though it can also be
      used to provide a secure endpoint into your network.
    '';
    homepage = "https://github.com/jpillora/chisel";
    changelog = "https://github.com/jpillora/chisel/releases/tag/v${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
