{
  lib,
  stdenv,
  fetchgit,
  testers,
  versionCheckHook,
  zlib,
  gnutlsSupport ? false,
  gnutls,
  nettle,
  opensslSupport ? true,
  openssl,
}:

assert (gnutlsSupport || opensslSupport);

stdenv.mkDerivation (finalAttrs: {
  pname = "rtmpdump";
  version = "2.6";

  src = fetchgit {
    url = "git://git.ffmpeg.org/rtmpdump";
    # Releases are not tagged.
    rev = "6f6bb1353fc84f4cc37138baa99f586750028a01";
    hash = "sha256-rwMA9eougKnkpG+fe6vZIwOBt2CC1d9qI9a079EbE5o=";
  };

  postPatch = ''
    for file in rtmp{dump.1,gw.8}{,.html} librtmp/librtmp.3{,.html}; do
      substituteInPlace "$file" \
        --replace-fail "RTMPDump v2.4" "RTMPDump v${finalAttrs.version}"
    done

    for file in Makefile librtmp/Makefile; do
      substituteInPlace "$file" \
        --replace-fail "VERSION=v2.4" "VERSION=v${finalAttrs.version}"
    done
  '';

  preBuild = ''
    makeFlagsArray+=(CC="$CC")
  '';

  makeFlags = [
    "prefix=$(out)"
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ]
  ++ lib.optional gnutlsSupport "CRYPTO=GNUTLS"
  ++ lib.optional opensslSupport "CRYPTO=OPENSSL"
  ++ lib.optional stdenv.hostPlatform.isDarwin "SYS=darwin";

  propagatedBuildInputs = [
    zlib
  ]
  ++ lib.optionals gnutlsSupport [
    gnutls
    nettle
  ]
  ++ lib.optional opensslSupport openssl;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--help";
  doInstallCheck = true;

  outputs = [
    "out"
    "dev"
  ];

  # incdir hardcoded to ${prefix}/include, but we move includes to -dev
  # pkg-config version field is specified without "v" prefix
  postFixup = ''
    substituteInPlace $dev/lib/pkgconfig/librtmp.pc \
      --replace-fail 'incdir=''${prefix}/include' "incdir=$dev/include" \
      --replace-fail 'Version: v${finalAttrs.version}' 'Version: ${finalAttrs.version}'
  '';

  separateDebugInfo = true;

  passthru.tests.pkg-config = testers.hasPkgConfigModules {
    package = finalAttrs.finalPackage;
    versionCheck = true;
  };

  meta = {
    description = "Toolkit for RTMP streams";
    homepage = "https://rtmpdump.mplayerhq.hu/";
    changelog = "https://rtmpdump.mplayerhq.hu/ChangeLog";
    license = lib.licenses.gpl2Plus;
    mainProgram = "rtmpdump";
    pkgConfigModules = [ "librtmp" ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ tmarkus ];
  };
})
