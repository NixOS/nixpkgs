{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "chisel";
  version = "1.11.4";

  src = fetchFromGitHub {
    owner = "jpillora";
    repo = "chisel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g0UjjzH22ri/tYMO8HDQ6zjis9z6ojRsQJIP5AGhjfM=";
  };

  vendorHash = "sha256-hqHd+62csVjHY2oAvi5fwlI0LbjR/LSDg6b1SMwe8Fw=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/jpillora/chisel/share.BuildVersion=${finalAttrs.version}"
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
    changelog = "https://github.com/jpillora/chisel/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
