{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  libpostalWithData,
}:
buildGoModule (finalAttrs: {
  pname = "amass";
  version = "5.1.1";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libpostalWithData ];

  src = fetchFromGitHub {
    owner = "OWASP";
    repo = "Amass";
    tag = "v${finalAttrs.version}";
    hash = "sha256-d4zy64W5cIseOVAaekN5Q4I5WuLz+M/cP7FXQ3CQ+mk=";
  };

  vendorHash = "sha256-3MpE61ixMps4IRIZkqjzG225zk4fsERkssoNoItUXbQ=";

  # https://github.com/OWASP/Amass/issues/640
  doCheck = false;

  meta = {
    description = "In-Depth DNS Enumeration and Network Mapping";
    longDescription = ''
      The OWASP Amass tool suite obtains subdomain names by scraping data
      sources, recursive brute forcing, crawling web archives,
      permuting/altering names and reverse DNS sweeping. Additionally, Amass
      uses the IP addresses obtained during resolution to discover associated
      netblocks and ASNs. All the information is then used to build maps of the
      target networks.
    '';
    homepage = "https://owasp.org/www-project-amass/";
    changelog = "https://github.com/OWASP/Amass/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kalbasit
      fab
    ];
    mainProgram = "amass";
  };
})
