{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libmilter,
  perl,
  perlPackages,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opendmarc";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "trusteddomainproject";
    repo = "opendmarc";
    rev = "rel-opendmarc-${builtins.replaceStrings [ "." ] [ "-" ] finalAttrs.version}";
    hash = "sha256-vnWtTvHhzCed7P6rN3wAz6zfRvtV0cLn5GhDxLF8H3c=";
  };

  outputs = [
    "bin"
    "dev"
    "out"
    "doc"
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    # gcc15 build failure
    "-std=gnu17"
  ];

  buildInputs = [ perl ];
  nativeBuildInputs = [
    autoreconfHook
    makeWrapper
  ];

  postPatch = ''
    substituteInPlace configure.ac --replace '	docs/Makefile' ""
    patchShebangs contrib reports
  '';

  configureFlags = [
    "--with-milter=${libmilter}"
  ];

  postFixup = ''
    for b in $bin/bin/opendmarc-{expire,import,params,reports}; do
      wrapProgram $b --set PERL5LIB ${
        perlPackages.makeFullPerlPath (
          with perlPackages;
          [
            Switch
            DBI
            DBDmysql
            HTTPMessage
          ]
        )
      }
    done
  '';

  meta = {
    description = "Free open source software implementation of the DMARC specification";
    homepage = "http://www.trusteddomain.org/opendmarc/";
    license = with lib.licenses; [
      bsd3
      sendmail
    ];
    maintainers = with lib.maintainers; [
      das_j
      helsinki-Jo
    ];
  };
})
