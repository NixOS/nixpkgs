{
  lib,
  stdenv,
  fetchurl,
  openssl,
  perl,
  which,
  dns-root-data,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "ldns";
  version = "1.8.4";

  src = fetchurl {
    url = "https://www.nlnetlabs.nl/downloads/ldns/${pname}-${version}.tar.gz";
    sha256 = "sha256-g4uQdZS6r/HNdn6VRmp3RZmK5kvHS+A43Mxi4t4uQkc=";
  };

  postPatch = ''
    patchShebangs doc/doxyparse.pl
  '';

  outputs = [
    "out"
    "dev"
    "man"
    "examples"
  ];

  nativeBuildInputs = [
    perl
    autoreconfHook
  ];

  buildInputs = [ openssl ];

  configureFlags =
    [
      "--with-ssl=${openssl.dev}"
      "--with-trust-anchor=${dns-root-data}/root.key"
      "--with-drill"
      "--disable-gost"
      "--with-examples"
    ]
    ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
      "ac_cv_func_malloc_0_nonnull=yes"
      "ac_cv_func_realloc_0_nonnull=yes"
    ];

  nativeCheckInputs = [ which ];
  doCheck = false; # fails. missing some files

  postInstall = ''
    # Only 'drill' stays in $out
    # the rest are examples:
    moveToOutput "bin/ldns*" "$examples"
    # with exception of ldns-config, which goes to $dev:
    moveToOutput "bin/ldns-config" "$dev"
  '';

  meta = with lib; {
    description = "Library with the aim of simplifying DNS programming in C";
    homepage = "http://www.nlnetlabs.nl/projects/ldns/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dtzWill ];
    mainProgram = "drill";
    platforms = platforms.unix;
  };
}
