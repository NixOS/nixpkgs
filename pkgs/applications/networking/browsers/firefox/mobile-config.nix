{
  runCommand,
  fetchFromGitLab,
  wrapFirefox,
  firefox-unwrapped,
}:

let
  pkg = fetchFromGitLab {
    owner = "postmarketOS";
    repo = "mobile-config-firefox";
    rev = "3fbea365e9ea7bcd317d5d4ef7723f994bbdc381";
    sha256 = "sha256-pgDMXnEdQg7d1lfGym4V+tsi6JAMgMVGI5ozSu0j0og=";
  };
  mobileConfigDir = runCommand "mobile-config-firefox" { } ''
    mkdir -p $out/mobile-config-firefox/{common,userChrome,userContent}

    cp ${pkg}/src/common/*.css $out/mobile-config-firefox/common/
    cp ${pkg}/src/userChrome/*.css $out/mobile-config-firefox/userChrome/
    cp ${pkg}/src/userContent/*.css $out/mobile-config-firefox/userContent/

    (cd $out/mobile-config-firefox && find common -name "*.css" | sort) >> $out/mobile-config-firefox/userChrome.files
    (cd $out/mobile-config-firefox && find common -name "*.css" | sort) >> $out/mobile-config-firefox/userContent.files

    (cd $out/mobile-config-firefox && find userChrome -name "*.css" | sort) > $out/mobile-config-firefox/userChrome.files
    (cd $out/mobile-config-firefox && find userContent -name "*.css" | sort) > $out/mobile-config-firefox/userContent.files

  '';

  mobileConfigAutoconfig = runCommand "mobile-config-autoconfig.js" { } ''
    substitute ${pkg}/src/mobile-config-autoconfig.js $out \
      --replace "/etc/mobile-config-firefox" "${mobileConfigDir}/mobile-config-firefox"
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
