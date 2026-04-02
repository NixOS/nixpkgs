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

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libgcrypt
    libgpg-error
    libtasn1
    # TODO use lib.optional instead of setting packages to null
    (if usePam then pam else null)
    (if useLibidn then libidn else null)
    (if useGnutls then gnutls else null)
  ];

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

  env.NIX_CFLAGS_COMPILE = optionalString stdenv.hostPlatform.isDarwin "-DBIND_8_COMPAT";

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

  meta = {
    homepage = "https://www.gnu.org/software/shishi/";
    description = "Implementation of the Kerberos 5 network security system";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
