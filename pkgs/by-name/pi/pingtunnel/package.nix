{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "pingtunnel";
  version = "2.10";

  src = fetchFromGitHub {
    owner = "esrrhs";
    repo = "pingtunnel";
    rev = finalAttrs.version;
    hash = "sha256-zQf091/BTVvnor8XLHtY1WP1QVcSm0O3k0/+X4bJMSQ=";
  };

  vendorHash = "sha256-LXaUNprIC9hEUvY5UtZ9WQxWw419ie6mM3eP/q2REMY=";

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/pingtunnel
  '';

  meta = {
    description = "Tool that send TCP/UDP traffic over ICMP";
    homepage = "https://github.com/esrrhs/pingtunnel";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ oluceps ];
    mainProgram = "pingtunnel";
  };
})
