{ firefox-unwrapped
, lib
, fetchFromGitLab
, stdenv
, wrapFirefox
, firefoxLibName ? "firefox"
, forceWayland ? true
, keepHomepage ? true
}:
let
  version = "2.0.1";

  mobile-config-firefox = stdenv.mkDerivation {
    pname = "mobile-config-firefox";
    inherit version;

    src = fetchFromGitLab {
      owner = "postmarketOS";
      repo = "mobile-config-firefox";
      rev = version;
      sha256 = "0kqq31h4qdqbn8y65jz27rsn7v85q3bdprdx1fb0c9s3g9lh5zqx";
    };

    makeFlags = [ "DISTRO=NixOS" ];

    installPhase = ''
      mkdir $out
      cp out/home.html $out/
      cp out/userChrome.css $out/
      cp src/mobile-config-autoconfig.js $out/
      cp src/mobile-config-prefs.js $out/
    '';

    fixupPhase = ''
      substituteInPlace $out/mobile-config-autoconfig.js \
        --replace "/etc/mobile-config-firefox/userChrome.css" "$out/userChrome.css"
    '';

    meta = with lib; {
      description = "Mobile-friendly Firefox configurations from postmarketOS";
      homepage = "https://gitlab.com/postmarketOS/mobile-config-firefox";
      license = licenses.gpl3Plus;
      maintainers = with maintainers; [ zhaofengli ];
    };
  };

  extraPolicies = let
    source = import ./policies.nix;
    policies = lib.recursiveUpdate source.policies {
      Homepage.URL = "${mobile-config-firefox}/home.html";
    };
  in assert (lib.assertMsg (source.version == version) "policies.nix is out of date. Run generate.sh to update it.");
    if keepHomepage then builtins.removeAttrs policies [ "Homepage" ] else policies;

  wrapped = wrapFirefox firefox-unwrapped {
    version = "${lib.getVersion firefox-unwrapped}-pmos-${version}";
    inherit forceWayland firefoxLibName extraPolicies;

    waylandDesktopSuffix = "";
  };
in wrapped.overrideAttrs (old: {
  buildCommand = old.buildCommand + ''
    # Inject default configs with AutoConfig commented out
    # They are problematic as the AutoConfig file is specified by wrapFirefox
    sed '/general\.config\.\(filename\|obscure_value\)/ s|^|//|g' < "${mobile-config-firefox}/mobile-config-prefs.js" > "$out/lib/${firefoxLibName}/defaults/pref/mobile-config-prefs.js"

    # Inject forced configs
    cat "${mobile-config-firefox}/mobile-config-autoconfig.js" >> "$out/lib/${firefoxLibName}/mozilla.cfg"
  '';
})
