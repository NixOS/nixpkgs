{
  lib,
  stdenv,
  fetchurl,
  lynx,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jwhois";
  version = "4.0";

  src = fetchurl {
    url = "mirror://gnu/jwhois/jwhois-${finalAttrs.version}.tar.gz";
    hash = "sha256-+pu4Z4K5FcbXMLtyP4dtybNFphfbN1qvNBbsIlU81k4=";
  };

  patches = [
    ./connect.patch
    ./service-name.patch
  ];

  postPatch = ''
    # avoids error on darwin where `-Werror=implicit-function-declaration` is set by default
    sed 1i'void timeout_init();' -i src/jwhois.c

    substituteInPlace example/jwhois.conf \
        --replace-fail "/usr/bin/lynx" ${lib.getExe lynx}
  '';

  makeFlags = [ "AR=${stdenv.cc.bintools.targetPrefix}ar" ];

  postInstall = ''
    ln -s $out/bin/jwhois $out/bin/whois
  '';

  # Work around error from <stdio.h> on aarch64-darwin:
  #     error: 'TARGET_OS_IPHONE' is not defined, evaluates to 0 [-Werror,-Wundef-prefix=TARGET_OS_]
  # TODO: this should probably be fixed at a lower level than this?
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-Wno-undef-prefix";

  env.NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-liconv";

  meta = {
    description = "Client for the WHOIS protocol allowing you to query the owner of a domain name";
    homepage = "https://www.gnu.org/software/jwhois/";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
  };
})
