{
  lib,
  stdenv,
  buildPackages,
  fetchFromGitHub,
  flex,
  db4,
  gettext,
  ninja,
  audit,
  linuxHeaders,
  libxcrypt,
  bash,
  bashNonInteractive,
  nixosTests,
  meson,
  pkg-config,
  systemdLibs,
  docbook5,
  libxslt,
  libxml2,
  w3m-batch,
  findXMLCatalogs,
  docbook_xsl_ns,
  nix-update-script,
  withLogind ? lib.meta.availableOn stdenv.hostPlatform systemdLibs,
  withAudit ?
    lib.meta.availableOn stdenv.hostPlatform audit
    # cross-compilation only works from platforms with linux headers
    && lib.meta.availableOn stdenv.buildPlatform linuxHeaders,
  debugMode ? false, # warning: slower execution due to debug makes VM tests fail!
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "linux-pam";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "linux-pam";
    repo = "linux-pam";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kANcwxifQz2tYPSrSBSFiYNTm51Gr10L/zroCqm8ZHQ=";

  };

  __structuredAttrs = true;

  # patching unix_chkpwd is required as the nix store entry does not have the necessary bits
  postPatch = ''
    substituteInPlace modules/module-meson.build \
      --replace-fail "sbindir / 'unix_chkpwd'" "'/run/wrappers/bin/unix_chkpwd'"
  '';

  outputs = [
    "out"
    "doc"
    "man"
    "scripts"
    # "modules"
  ];

  strictDeps = true;

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [
    flex
    meson
    ninja
    pkg-config
    gettext

    libxslt
    libxml2
    w3m-batch
    findXMLCatalogs
    docbook_xsl_ns
    docbook5
  ];

  buildInputs = [
    db4
    libxcrypt
    bash
  ]
  ++ lib.optionals withAudit [
    audit
  ]
  ++ lib.optionals withLogind [
    systemdLibs
  ];

  enableParallelBuilding = true;

  mesonAutoFeatures = "auto";
  mesonFlags = [
    (lib.mesonEnable "logind" withLogind)
    (lib.mesonEnable "audit" withAudit)
    (lib.mesonEnable "pam_lastlog" (!stdenv.hostPlatform.isMusl)) # TODO: switch to pam_lastlog2, pam_lastlog is deprecated and broken on musl
    (lib.mesonEnable "pam_unix" true)
    (lib.mesonOption "sysconfdir" "etc") # relative to meson prefix, which is $out
    (lib.mesonEnable "elogind" false)
    (lib.mesonEnable "econf" false)
    (lib.mesonEnable "selinux" false)
    (lib.mesonEnable "nis" false)
    (lib.mesonBool "xtests" false)
    (lib.mesonBool "examples" false)
  ]
  # warning: slower execution due to debug makes VM tests fail!
  ++ lib.optional debugMode (lib.mesonBool "pam-debug" true);

  postInstall = ''
    moveToOutput sbin/pam_namespace_helper $scripts
    moveToOutput etc/security/namespace.init $scripts
  '';

  doCheck = false; # fails

  outputChecks.out.disallowedRequisites = [
    bash
    bashNonInteractive
  ];

  passthru = {
    tests = {
      inherit (nixosTests)
        pam-oath-login
        pam-u2f
        pam-lastlog
        shadow
        sssd-ldap
        ;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/linux-pam/linux-pam/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/linux-pam/linux-pam";
    description = "Pluggable Authentication Modules, a flexible mechanism for authenticating user";
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd3;
    badPlatforms = [ lib.systems.inspect.platformPatterns.isStatic ];
  };
})
