{
  runCommand,
  fetchFromGitLab,
  wrapFirefox,
  firefox-unwrapped,
}:

let
  pkg = fetchFromGitLab {
    domain = "gitlab.postmarketos.org";
    owner = "postmarketOS";
    repo = "mobile-config-firefox";
    rev = "5.4.1";
    hash = "sha256-MyhGl1gIjDtNUMLoHz15l5RaJWDcTeBgZl0Gb8WHcUg=";
  };
  mobileConfigDir = runCommand "mobile-config-firefox" { } ''
    mkdir -p $out
    cp -r ${pkg}/src/modules/. $out/
    cp -r ${pkg}/src/themes $out/
  '';

  mobileConfigAutoconfig = runCommand "mobile-config-autoconfig.js" { } ''
    substitute ${pkg}/src/mobile-config-autoconfig.js $out \
      --replace-fail "/usr/lib/mobile-config-firefox" "${mobileConfigDir}"
  '';

  mobileConfigPrefs = runCommand "mobile-config-prefs.js" { } ''
    # Remove the autoconfig setup lines since we handle that through extraPrefsFiles
    grep -v "general.config.filename" ${pkg}/src/mobile-config-prefs.js | \
    grep -v "general.config.obscure_value" | \
    grep -v "general.config.sandbox_enabled" > $out
  '';
in
wrapFirefox firefox-unwrapped {
  extraPrefsFiles = [
    mobileConfigAutoconfig
    mobileConfigPrefs
  ];

  extraPoliciesFiles = [
    "${pkg}/src/policies.json"
  ];
}
