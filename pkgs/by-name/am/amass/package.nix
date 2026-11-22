{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  pkg-config,
  libpostalWithData,
}:

buildGo127Module (finalAttrs: {
  pname = "amass";
  version = "5.1.3";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libpostalWithData ];

  src = fetchFromGitHub {
    owner = "owasp-amass";
    repo = "Amass";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XypU8Z2RptwXM0vrLqsK+oglt8p4LVv7o9COIq261ro=";
  };

  vendorHash = "sha256-5gRMV65BmDepQyKSY78XHkxOybVav7MlRzqX7gSoi4A=";

  # https://github.com/owasp-amass/amass/issues/640
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
    changelog = "https://github.com/owasp-amass/amass/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kalbasit
      fab
    ];
    mainProgram = "amass";
  };
})
