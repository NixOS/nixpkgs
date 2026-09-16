{
  lib,
  stdenv,
  fetchurl,
  asciidoctor,
  bison,
  directoryListingUpdater,
  iana-etc,
  libcap,
  libseccomp,
  openssl,
  pkg-config,
  pps-tools,
  python3,
  versionCheckHook,
  wafHook,
  withDocs ? true,
  withSeccomp ? stdenv.hostPlatform.isLinux,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ntpsec";
  version = "1.2.5";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://ftp.ntpsec.org/pub/releases/ntpsec-${finalAttrs.version}.tar.gz";
    hash = "sha256-b7GRzdr2B+d1Sx9pFaGmHcQBiz5O7z0v+s7JYcloKUk=";
  };

  outputs = [
    "out"
  ]
  ++ lib.optionals withDocs [
    "doc"
    "man"
  ];

  nativeBuildInputs = [
    bison
    pkg-config
    python3
    python3.pkgs.wrapPython
    wafHook
  ]
  ++ lib.optionals withDocs [ asciidoctor ];

  buildInputs = [
    libcap
    openssl
    pps-tools
  ]
  ++ lib.optionals withSeccomp [ libseccomp ];

  wafConfigureFlags = [
    "--pyshebang=${python3.interpreter}"
    "--refclock=all"
  ]
  ++ (
    if withDocs then
      [
        "--enable-doc"
        "--enable-manpage"
      ]
    else
      [
        "--disable-doc"
        "--disable-manpage"
      ]
  )
  ++ lib.optionals withSeccomp [ "--enable-seccomp" ];

  wafBuildFlags = [ "--notests" ];

  wafInstallFlags = [ "--destdir=/" ];

  postFixup = ''
    wrapPythonPrograms
  '';

  doCheck = true;

  nativeCheckInputs = [ iana-etc ];

  checkPhase = ''
    runHook preCheck

    ./waf check

    runHook postCheck
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;

  passthru.updateScript = directoryListingUpdater { ignoredVersions = "-rc"; };

  meta = {
    description = "Secure, hardened, and improved implementation of Network Time Protocol";
    homepage = "https://www.ntpsec.org/";
    downloadPage = "https://ftp.ntpsec.org/pub/releases/";
    changelog = "https://gitlab.com/NTPsec/ntpsec/-/blob/NTPsec_${
      lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version
    }/NEWS.adoc";
    license = with lib.licenses; [
      bsd2
      isc
      cc-by-40
      hpnd
    ];
    maintainers = with lib.maintainers; [ liberodark ];
    platforms = lib.platforms.linux;
    mainProgram = "ntpd";
  };
})
