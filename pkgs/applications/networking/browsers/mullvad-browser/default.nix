{ lib
, buildMozillaMach
, fetchFromGitHub
, stdenv
, firefox-esr
, nix-update-script
}:
((buildMozillaMach rec {
  pname = "mullvad-browser";
  applicationName = "Mullvad Browser";
  binaryName = "mullvadbrowser";
  branding = "browser/branding/mb-release";
  # mullvad-browser is based on firefox ESR but since we can't properly keep track of the exact ESR version it uses,
  # we will just inherit it here from the version in nixpkgs. The reason we need to use a firefox version is because
  # some patches are applied conditionally with lib.versionAtLeast.
  version = "${firefox-esr.version}-dummy"; # TODO: find a better solution as this will trigger rebuilds if changed.

  src = fetchFromGitHub {
    owner = "mullvad";
    repo = "mullvad-browser";
    rev = "12.0.6";
    hash = "sha256-XTfNYRuA+NSHhB7KHALUBNC2yJlxLqxZFpZQNgEqAqI=";
  };

  extraConfigureFlags = [
    "--with-app-name=mullvadbrowser"
    "--with-app-basename=MullvadBrowser"
    "--with-base-browser-version=${src.rev}"
    "--with-unsigned-addon-scopes=app,system"
    "--allow-addon-sideload"
  ];

  meta = {
    description = "Privacy-focused browser made in a collaboration between The Tor Project and Mullvad (Fork of Firefox)";
    homepage = "https://mullvad.net/browser";
    maintainers = with lib.maintainers; [ felschr ];
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.darwin;
    broken = stdenv.buildPlatform.is32bit; # since Firefox 60, build on 32-bit platforms fails with "out of memory".
    # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
    maxSilent = 14400; # 4h, double the default of 7200s (c.f. #129212, #129115)
    license = lib.licenses.mpl20;
  };
}).override {
  crashreporterSupport = false;
  enableOfficialBranding = false;
}).overrideAttrs (oa: {
  passthru = {
    realVersion = oa.src.rev;
    updateScript = nix-update-script {
      # TODO: Make it work? It doesn't seem to make any changes to the file. realistically I want it to only change the src.
      extraArgs = [ "--version-regex" "([^a-zA-Z]+[0-9.]+)" ];
    };
  };
  MOZ_REQUIRE_SIGNING = "";
})
