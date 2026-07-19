{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libgcrypt,
  libgpg-error,
  libtasn1,

  # Optional Dependencies
  usePam ? lib.meta.availableOn stdenv.hostPlatform pam && stdenv.hostPlatform.isLinux,
  pam,
  useLibidn ? lib.meta.availableOn stdenv.hostPlatform libidn,
  libidn,
  useGnutls ? lib.meta.availableOn stdenv.hostPlatform gnutls,
  gnutls,
  pkgsStatic,
}:

let
  inherit (lib) enableFeature withFeature optionalString;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "shishi";
  version = "1.0.3";

  src = fetchurl {
    url = "mirror://gnu/shishi/shishi-${finalAttrs.version}.tar.gz";
    hash = "sha256-lXmP/RLdAaT4jgMR7gPKSibly05ekFmkDk/E2fKRfpI=";
  };

  separateDebugInfo = true;

  nativeBuildInputs = [
    libgcrypt
    pkg-config
  ];

  buildInputs = [
    libgcrypt
    libgpg-error
    libtasn1
  ]
  ++ lib.optionals usePam [ pam ]
  ++ lib.optionals useLibidn [ libidn ]
  ++ lib.optionals useGnutls [ gnutls ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    (enableFeature true "libgcrypt")
    (enableFeature usePam "pam")
    (enableFeature true "ipv6")
    (withFeature useLibidn "stringprep")
    (enableFeature useGnutls "starttls")
    (enableFeature true "des")
    (enableFeature true "3des")
    (enableFeature true "aes")
    (enableFeature true "md")
    (enableFeature false "null")
    (enableFeature true "arcfour")
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    (optionalString stdenv.hostPlatform.isDarwin "-DBIND_8_COMPAT")
    # gnulib's crc.c exports a "crc32" symbol (unused by shishi, which only calls crc32_update_no_xor).
    # On static builds it conflicts with "crc32" from zlib (transitive dependency of gnutls).
    (optionalString stdenv.hostPlatform.isStatic "-Dcrc32=shishi_gnulib_crc32")
  ];

  doCheck = true;

  installFlags = [ "sysconfdir=\${out}/etc" ];

  # Fix *.la files
  postInstall = ''
    sed -i $out/lib/libshi{sa,shi}.la \
  ''
  + optionalString useLibidn ''
    -e 's,\(-lidn\),-L${libidn.out}/lib \1,' \
  ''
  + optionalString useGnutls ''
    -e 's,\(-lgnutls\),-L${gnutls.out}/lib \1,' \
  ''
  + ''
    -e 's,\(-lgcrypt\),-L${libgcrypt.out}/lib \1,' \
    -e 's,\(-lgpg-error\),-L${libgpg-error.out}/lib \1,' \
    -e 's,\(-ltasn1\),-L${libtasn1.out}/lib \1,'
  '';

  strictDeps = true;

  passthru = {
    tests = {
      static = pkgsStatic.shishi;
    };
  };

  meta = {
    homepage = "https://www.gnu.org/software/shishi/";
    description = "Implementation of the Kerberos 5 network security system";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
