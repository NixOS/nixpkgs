{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "3.3.4";
  pname = "modsecurity-crs";

  src = fetchFromGitHub {
    owner = "coreruleset";
    repo = "coreruleset";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-WDJW4K85YdHrw9cys3LrnZUoTxc0WhiuCW6CiC1cAbk=";
  };

  installPhase = ''
    install -D -m444 -t $out/rules ${finalAttrs.src}/rules/*.conf
    install -D -m444 -t $out/rules ${finalAttrs.src}/rules/*.data
    install -D -m444 -t $out/share/doc/modsecurity-crs ${finalAttrs.src}/*.md
    install -D -m444 -t $out/share/doc/modsecurity-crs ${finalAttrs.src}/{CHANGES,INSTALL,LICENSE}
    install -D -m444 -t $out/share/modsecurity-crs ${finalAttrs.src}/rules/*.example
    install -D -m444 -t $out/share/modsecurity-crs ${finalAttrs.src}/crs-setup.conf.example
    cat > $out/share/modsecurity-crs/modsecurity-crs.load.example <<EOF
    ##
    ## This is a sample file for loading OWASP CRS's rules.
    ##
    Include /etc/modsecurity/crs/crs-setup.conf
    IncludeOptional /etc/modsecurity/crs/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf
    Include $out/rules/*.conf
    IncludeOptional /etc/modsecurity/crs/RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf
    EOF
  '';

  meta = {
    homepage = "https://coreruleset.org";
    description = ''
      The OWASP ModSecurity Core Rule Set is a set of generic attack detection
      rules for use with ModSecurity or compatible web application firewalls.
    '';
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ izorkin ];
  };
})
