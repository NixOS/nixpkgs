{ stdenv
, lib
, fetchFromGitHub
, buildMozillaMach
, nixosTests
}:

((buildMozillaMach rec {
  pname = "floorp";
  packageVersion = "11.5.0";
  applicationName = "Floorp";
  binaryName = "floorp";
  version = "155.4.0";

  src = fetchFromGitHub {
    owner = "Floorp-Projects";
    repo = "Floorp";
    fetchSubmodules = true;
    rev = "v${packageVersion}";
    hash = "sha256-adK3LAu3cDh6d+GvtnkWmSnxansnSZoIgtA9TAqIMyA=";
  };

  extraConfigureFlags = [
    "--with-app-name=${pname}"
    "--with-app-basename=${applicationName}"
    "--with-branding=browser/branding/official"
    "--with-distribution-id=app.floorp.Floorp"
    "--with-unsigned-addon-scopes=app,system"
    "--allow-addon-sideload"
  ];

  meta = {
    description = "A fork of Firefox, focused on keeping the Open, Private and Sustainable Web alive, built in Japan";
    homepage = "https://floorp.app/";
    maintainers = with lib.maintainers; [ christoph-heiss ];
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.darwin;
    broken = stdenv.buildPlatform.is32bit; # since Firefox 60, build on 32-bit platforms fails with "out of memory".
                                           # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
    maxSilent = 14400; # 4h, double the default of 7200s (c.f. #129212, #129115)
    license = lib.licenses.mpl20;
  };
  tests = [ nixosTests.floorp ];
}).override {
  privacySupport = true;
  enableOfficialBranding = false;
}).overrideAttrs (prev: {
  MOZ_REQUIRE_SIGNING = "";
})
