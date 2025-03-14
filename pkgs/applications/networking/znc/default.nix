{
  lib,
  stdenv,
  fetchurl,
  fetchpatch2,
  openssl,
  pkg-config,
  withPerl ? false,
  perl,
  withPython ? false,
  python3,
  withTcl ? false,
  tcl,
  withCyrus ? true,
  cyrus_sasl,
  withUnicode ? true,
  icu,
  withZlib ? true,
  zlib,
  withIPv6 ? true,
  withDebug ? false,
}:

stdenv.mkDerivation rec {
  pname = "znc";
  version = "1.8.2";

  src = fetchurl {
    url = "https://znc.in/releases/archive/${pname}-${version}.tar.gz";
    sha256 = "03fyi0j44zcanj1rsdx93hkdskwfvhbywjiwd17f9q1a7yp8l8zz";
  };

  patches = [
    (fetchpatch2 {
      name = "CVE-2024-39844.patch";
      url = "https://github.com/znc/znc/commit/8cbf8d628174ddf23da680f3f117dc54da0eb06e.patch";
      hash = "sha256-JeKirXReiCiNDUS9XodI0oHASg2mPDvQYtV6P4L0mHM=";
    })
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [ openssl ]
    ++ lib.optional withPerl perl
    ++ lib.optional withPython python3
    ++ lib.optional withTcl tcl
    ++ lib.optional withCyrus cyrus_sasl
    ++ lib.optional withUnicode icu
    ++ lib.optional withZlib zlib;

  configureFlags =
    [
      (lib.enableFeature withPerl "perl")
      (lib.enableFeature withPython "python")
      (lib.enableFeature withTcl "tcl")
      (lib.withFeatureAs withTcl "tcl" "${tcl}/lib")
      (lib.enableFeature withCyrus "cyrus")
    ]
    ++ lib.optionals (!withIPv6) [ "--disable-ipv6" ]
    ++ lib.optionals withDebug [ "--enable-debug" ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Advanced IRC bouncer";
    homepage = "https://wiki.znc.in/ZNC";
    maintainers = with maintainers; [
      schneefux
      lnl7
    ];
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
