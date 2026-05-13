{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "opensmtpd-filter-rspamd";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "poolpOrg";
    repo = "filter-rspamd";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Ud1irvEyYr9QDsm2PsnWoWkXoDH0WWeH73k/IbLrVf4=";
  };

  vendorHash = "sha256-sNF2c+22FMvKoROkA/3KtSnRdJh4YZLaIx35HD896HI=";

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
