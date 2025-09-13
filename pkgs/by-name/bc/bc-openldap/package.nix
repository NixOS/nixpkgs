{
  lib,
  stdenv,
  fetchurl,

  # dependencies
  cyrus_sasl,
  groff,
  libsodium,
  libtool,
  openssl,
  systemdMinimal,
  libxcrypt,

  # options
  withModules ? !stdenv.hostPlatform.isStatic,

  fetchFromGitLab,
}:

stdenv.mkDerivation {
  pname = "bc-openldap";
  version = "linphone-5.1.2";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    group = "BC";
    owner = "public/external";
    repo = "openldap";
    rev = "2bca580b6b2ef22c44fbeaeabac6cbdc7c4756e7";
    hash = "sha256-KEKL8LdcBTnEs7R/8OrA3NEEt9BlM4r1vqDCxp89ulo=";
  };

  patches = [
    (fetchurl {
      name = "test069-sleep.patch";
      url = "https://bugs.openldap.org/attachment.cgi?id=1051";
      hash = "sha256-9LcFTswMQojrwHD+PRvlnSrwrISCFcboHypBwoDIZc0=";
    })
    ./0001-fix-tests-compile-error.patch
    ./0002-remove-client-executables-from-build.patch
  ];

  # TODO: separate "out" and "bin"
  outputs = [
    "out"
    "dev"
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    groff
  ];

  buildInputs =
    [
      (cyrus_sasl.override {
        inherit openssl;
      })
      libtool
      openssl
    ]
    ++ lib.optionals (stdenv.hostPlatform.isLinux) [
      libxcrypt # causes linking issues on *-darwin
    ]
    ++ lib.optionals withModules [
      libsodium
    ];

  configureFlags =
    [
      "--enable-crypt"
      "--enable-overlays"
      "--enable-slapd=no"
      (lib.enableFeature withModules "argon2")
      (lib.enableFeature withModules "modules")
    ]
    ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
      "--with-yielding_select=yes"
      "ac_cv_func_memcmp_working=yes"
    ];

  env.CFLAGS = toString ([
    "-Wno-implicit-int"
  ]);

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "STRIP=" # Disable install stripping as it breaks cross-compiling. We strip binaries anyway in fixupPhase.
    "STRIP_OPTS="
    "sysconfdir=/etc"
    "systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    "prefix=${placeholder "out"}"
    # contrib modules require these
    "moduledir=${placeholder "out"}/lib/modules"
    "mandir=${placeholder "out"}/share/man"
  ];

  extraContribModules = [
    # https://git.openldap.org/openldap/openldap/-/tree/master/contrib/slapd-modules
    "passwd/sha2"
    "passwd/pbkdf2"
    "passwd/totp"
  ];

  postBuild = ''
    for module in $extraContribModules; do
      make $makeFlags CC=$CC -C contrib/slapd-modules/$module
    done
  '';

  preCheck = ''
    substituteInPlace tests/scripts/all \
      --replace "/bin/rm" "rm"

    # skip flaky tests
    # https://bugs.openldap.org/show_bug.cgi?id=8623
    rm -f tests/scripts/test022-ppolicy

    rm -f tests/scripts/test063-delta-multiprovider

    # https://bugs.openldap.org/show_bug.cgi?id=10009
    # can probably be re-added once https://github.com/cyrusimap/cyrus-sasl/pull/772
    # has made it to a release
    rm -f tests/scripts/test076-authid-rewrite
  '';

  doCheck = true;

  installFlags = [
    "prefix=${placeholder "out"}"
    "sysconfdir=${placeholder "out"}/etc"
    "moduledir=${placeholder "out"}/lib/modules"
    "INSTALL=install"
  ];

  postInstall = lib.optionalString withModules ''
    for module in $extraContribModules; do
      make $installFlags install -C contrib/slapd-modules/$module
    done
    rm -r "$out/bin"
  '';

  meta = {
    homepage = "https://gitlab.linphone.org/BC/public/external/openldap";
    description = "Fork of OpenLDAP by Belledonne Communications";
    license = lib.licenses.openldap;
    maintainers = with lib.maintainers; [
      felixsinger
    ];
    platforms = lib.platforms.linux;
  };
}
