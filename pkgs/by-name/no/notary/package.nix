{ lib
, fetchFromGitHub
, buildGoModule
}:
buildGoModule rec {
  pname = "notary";
  version = "0.6.1-unstable-2024-04-16";

  src = fetchFromGitHub {
    owner = "notaryproject";
    repo = "notary";
    rev = "9d2b3b35929392c9945d976b8bdecbe2f53a299e";
    hash = "sha256-u19BfTJwRWholK0b3BcgSmcMM9AR7OeXo64AOi87r0A=";
  };

  vendorHash = null;

  tags = [
    "pkcs11"
  ];

  ldflags = [
    "-X github.com/theupdateframework/notary/version.NotaryVersion=${version}"
  ];

  # Tests try to use network.
  doCheck = false;

  meta = {
    description = "Project that allows anyone to have trust over arbitrary collections of data";
    mainProgram = "notary";
    longDescription = ''
      The Notary project comprises a server and a client for running and
      interacting with trusted collections. See the service architecture
      documentation for more information.

      Notary aims to make the internet more secure by making it easy for people
      to publish and verify content. We often rely on TLS to secure our
      communications with a web server which is inherently flawed, as any
      compromise of the server enables malicious content to be substituted for
      the legitimate content.

      With Notary, publishers can sign their content offline using keys kept
      highly secure. Once the publisher is ready to make the content available,
      they can push their signed trusted collection to a Notary Server.

      Consumers, having acquired the publisher's public key through a secure
      channel, can then communicate with any notary server or (insecure) mirror,
      relying only on the publisher's key to determine the validity and
      integrity of the received content.
    '';
    license = lib.licenses.asl20;
    homepage = "https://github.com/theupdateframework/notary";
    maintainers = [ lib.maintainers.vdemeester ];
    platforms = lib.platforms.unix;
  };
}
