{
  lib,
  stdenv,
  buildPackages,
  fetchurl,
  flex,
  db4,
  gettext,
  ninja,
  audit,
  libeconf,
  libxcrypt,
  nixosTests,
  cmake,
  meson,
  pkg-config,
  systemdMinimal,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "linux-pam";
  version = "1.7.1";

  src = fetchurl {
    url = "https://github.com/linux-pam/linux-pam/releases/download/v${finalAttrs.version}/Linux-PAM-${finalAttrs.version}.tar.xz";
    hash = "sha256-IdvOxuAd1XjxR4nqyQJKGJQebycCoFz5GyjCMu6yarA=";
  };

  postPatch =
    # patching unix_chkpwd is required as the nix store entry does not have the necessary bits
    ''
      substituteInPlace modules/module-meson.build \
        --replace-fail "sbindir / 'unix_chkpwd'" "'/run/wrappers/bin/unix_chkpwd'"
    ''
    # Case-insensitivity workaround for https://github.com/linux-pam/linux-pam/issues/569
    +
      lib.optionalString (stdenv.buildPlatform.isDarwin && stdenv.buildPlatform != stdenv.hostPlatform)
        ''
          rm CHANGELOG
          touch ChangeLog
        '';

  outputs = [
    "out"
    # "doc"
    # "man"
    # "modules"
  ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  # pkg-config-unwrapped is needed for `AC_CHECK_LIB` and `AC_SEARCH_LIBS`
  nativeBuildInputs = [
    cmake
    flex
    meson
    ninja
    pkg-config
    gettext
  ];

  buildInputs =
    [
      db4
      libeconf
      libxcrypt
    ]
    ++ lib.optionals stdenv.buildPlatform.isLinux [
      audit
      systemdMinimal
    ];

  enableParallelBuilding = true;

  mesonFlags = [
    (lib.mesonEnable "logind" stdenv.buildPlatform.isLinux)
    (lib.mesonEnable "audit" stdenv.buildPlatform.isLinux)
    (lib.mesonEnable "pam_lastlog" true) # TODO: switch to pam_lastlog2
    (lib.mesonEnable "pam_unix" true)
    # (lib.mesonBool "pam-debug" true) # warning: slower execution due to debug makes VM tests fail!
    (lib.mesonOption "sysconfdir" "etc") # relative to meson prefix, which is $out
    (lib.mesonEnable "elogind" false)
    (lib.mesonEnable "selinux" false)
    (lib.mesonEnable "nis" false)
    (lib.mesonEnable "docs" false)
    (lib.mesonBool "xtests" false)
    (lib.mesonBool "examples" false)
  ];

  dontUseCmakeConfigure = true;

  doCheck = false; # fails

  passthru.tests = {
    inherit (nixosTests)
      pam-oath-login
      pam-u2f
      shadow
      sssd-ldap
      ;
  };

  meta = {
    homepage = "https://github.com/linux-pam/linux-pam";
    description = "Pluggable Authentication Modules, a flexible mechanism for authenticating user";
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd3;
  };
})
