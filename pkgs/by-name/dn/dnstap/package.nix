{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
}:
buildGoModule rec {
  pname = "dnstap";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "dnstap";
    repo = "golang-dnstap";
    tag = "v${version}";
    hash = "sha256-GmwHJ6AQ4HcPEFNeodKqJe/mYE1Fa95hRiQWoka/nv4=";
  };

  vendorHash = "sha256-xDui88YgLqIETIR34ZdqT6Iz12v+Rdf6BssAIXgaMLU=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installManPage dnstap/dnstap.8
  '';

  meta = {
    description = "Structured DNS server events decoding utility";
    longDescription = ''
      dnstap implements an encoding format for DNS server events. It uses a
      lightweight framing on top of event payloads encoded using Protocol
      Buffers and is transport neutral.

      dnstap can represent internal state inside a DNS server that is difficult
      to obtain using techniques based on traditional packet capture or
      unstructured textual format logging.
    '';
    homepage = "https://dnstap.info";
    changelog = "https://github.com/dnstap/golang-dnstap/releases/tag/${src.rev}";
    license = lib.licenses.asl20;
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = [ lib.maintainers.azahi ];
    mainProgram = "dnstap";
  };
}
