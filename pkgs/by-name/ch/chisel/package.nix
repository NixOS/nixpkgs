{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "chisel";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "jpillora";
    repo = "chisel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-w2078KF5vN0aSsm8i5zko42ZaN7zhF4I0gRrKi+PBXo=";
  };

  vendorHash = "sha256-TdUFhzpfMWfUq9eaoGQbnfkujF2YDGmRAkxqKpisA+8=";

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
