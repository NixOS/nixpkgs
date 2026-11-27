{
  swig,
  fetchFromGitHub,
}:

## for updating to SWIG 4, see
## https://github.com/GeraldWodni/swig/pull/6
swig.overrideAttrs (old: {
  version = "3.0.9-forth";

  src = fetchFromGitHub {
    owner = "GeraldWodni";
    repo = "swig";
    rev = "d9a1e4f88bdc6f8829438902aebeeea2ce5d2eee";
    sha256 = "sha256-ell63rIfnmFsUhyQl7OzP3kiVYUfPCDhrTFaw2KIEPQ=";
  };

  configureFlags = old.configureFlags ++ [
    "--with-forth=yes"
    # SWIG 3 needs the removed pcre (not pcre2); it is only used for regex %rename, which gforth doesn't use
    "--without-pcre"
  ];
})
