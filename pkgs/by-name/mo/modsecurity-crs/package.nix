{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "modsecurity-crs";
  version = "4.31.0";

  src = fetchFromGitHub {
    owner = "coreruleset";
    repo = "coreruleset";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jyhPin4jM3uLQ/JUPPsUL0I4Mn+NvmLhOuVLRAZVAo0=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/rules rules/*.conf rules/*.data
    install -D -m444 -t $out/share/doc/modsecurity-crs \
      {CHANGES,INSTALL,KNOWN_BUGS,PLUGIN-CONTRACT,README}.md LICENSE
    install -D -m444 -t $out/share/modsecurity-crs rules/*.example crs-setup.conf.example
    cat > $out/share/modsecurity-crs/modsecurity-crs.load.example <<EOF
    ##
    ## This is a sample file for loading OWASP CRS's rules.
    ##
    Include /etc/modsecurity/crs/crs-setup.conf
    IncludeOptional /etc/modsecurity/crs/plugins/*-config.conf
    IncludeOptional /etc/modsecurity/crs/plugins/*-before.conf
    IncludeOptional /etc/modsecurity/crs/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf
    Include $out/rules/*.conf
    IncludeOptional /etc/modsecurity/crs/RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf
    IncludeOptional /etc/modsecurity/crs/plugins/*-after.conf
    EOF

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://coreruleset.org";
    changelog = "https://github.com/coreruleset/coreruleset/releases/tag/${finalAttrs.src.tag}";
    description = "OWASP CRS, generic attack detection rules for ModSecurity and compatible WAFs";
    longDescription = ''
      The OWASP ModSecurity Core Rule Set is a set of generic attack detection
      rules for use with ModSecurity or compatible web application firewalls.
    '';
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ izorkin ];
  };
})
