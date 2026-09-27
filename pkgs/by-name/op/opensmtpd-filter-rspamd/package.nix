{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "opensmtpd-filter-rspamd";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "poolpOrg";
    repo = "filter-rspamd";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-mOUFTYXA+cJJpFjvnv9wOtxqAuxaaVqKfhV5Zds9wIY=";
  };

  vendorHash = "sha256-9Vq7TdjkJv7646fr9bJ2pZN443vIObAYcI8mzFrbX18=";

  passthru.tests = {
    opensmtpd-rspamd-integration = nixosTests.opensmtpd-rspamd;
  };

  meta = {
    description = "OpenSMTPD filter integration for the Rspamd daemon";
    homepage = "https://github.com/poolpOrg/filter-rspamd";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ Flakebi ];
    mainProgram = "filter-rspamd";
  };
})
