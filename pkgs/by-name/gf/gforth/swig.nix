{
  swig,
  pcre,
  fetchFromGitHub,
}:

## for updating to SWIG 4, see
## https://github.com/GeraldWodni/swig/pull/6
(swig.overrideAttrs (old: {
  version = "3.0.9-forth";

  src = fetchFromGitHub {
    owner = "GeraldWodni";
    repo = "swig";
    rev = "d9a1e4f88bdc6f8829438902aebeeea2ce5d2eee";
    hash = "sha256-ell63rIfnmFsUhyQl7OzP3kiVYUfPCDhrTFaw2KIEPQ=";
  };

  configureFlags = old.configureFlags ++ [ "--with-forth=yes" ];

  env.PCRE_CONFIG = "${pcre.dev}/bin/pcre-config";
})).override
  { pcre2 = pcre; }
