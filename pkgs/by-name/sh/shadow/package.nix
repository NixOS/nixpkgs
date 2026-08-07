{
  lib,
  stdenv,
  fetchFromGitHub,
  nixosTests,
  autoreconfHook,
  bison,
  flex,
  docbook_xml_dtd_45,
  docbook_xsl,
  itstool,
  libxml2,
  libxslt,
  libxcrypt,
  pkg-config,
  glibc ? null,
  pam ? null,
  withLibbsd ? lib.meta.availableOn stdenv.hostPlatform libbsd,
  libbsd,
  withTcb ? lib.meta.availableOn stdenv.hostPlatform tcb,
  tcb,
  cmocka,
  fetchpatch,
}:
let
  glibc' =
    if stdenv.hostPlatform != stdenv.buildPlatform then
      glibc
    else
      assert stdenv.hostPlatform.libc == "glibc";
      stdenv.cc.libc;

in

stdenv.mkDerivation (finalAttrs: {
  pname = "shadow";
  version = "4.19.4";

  src = fetchFromGitHub {
    owner = "shadow-maint";
    repo = "shadow";
    tag = finalAttrs.version;
    hash = "sha256-vR6dwB3EttGY2DgQ20nOr9kNhF+nsAaBEyklcJAZ20Y=";
  };

  outputs = [
    "out"
    "su"
    "dev"
    "man"
  ];

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    docbook_xml_dtd_45
    docbook_xsl
    itstool
    libxml2
    libxslt
    pkg-config
  ];

  buildInputs = [
    libxcrypt
  ]
  ++ lib.optional (pam != null && (lib.meta.availableOn stdenv.hostPlatform pam)) pam
  ++ lib.optional withLibbsd libbsd
  ++ lib.optional withTcb tcb;

  patches = [
    # Don't set $PATH to /bin:/usr/bin but inherit the $PATH of the caller.
    ./keep-path.patch
    # Obtain XML resources from XML catalog (patch adapted from gtk-doc)
    ./respect-xml-catalog-files-var.patch
    # Avoid a chown during install to fix installation with tcb enabled
    # Would have to be done as part of the NixOS modules,
    # see https://github.com/NixOS/nixpkgs/issues/109457
    ./fix-install-with-tcb.patch
  ];

  postPatch = ''
    # The nix daemon often forbids even creating set[ug]id files
    sed 's/^\(s[ug]idperms\) = [0-9]755/\1 = 0755/' -i src/Makefile.am

    # The default shell is not defined at build time of the package. It is
    # decided at build time of the NixOS configration. Thus, don't decide this
    # here but just point to the location of the shell on the system.
    substituteInPlace configure.ac --replace-fail '$SHELL' /bin/sh
  '';

  # `AC_FUNC_SETPGRP' is not cross-compilation capable.
  preConfigure = ''
    export ac_cv_func_setpgrp_void=${lib.boolToYesNo (!stdenv.hostPlatform.isBSD)}
    export shadow_cv_logdir=/var/log
  '';

  configureFlags = [
    "--enable-man"
    "--with-group-name-max-length=32"
    "--with-bcrypt"
    "--with-yescrypt"
    "--disable-logind" # needs systemd, which causes infinite recursion
    (lib.withFeature withLibbsd "libbsd")
  ]
  ++ lib.optional (stdenv.hostPlatform.libc != "glibc") "--disable-nscd"
  ++ lib.optional withTcb "--with-tcb";

  preBuild = lib.optionalString (stdenv.hostPlatform.libc == "glibc") ''
    substituteInPlace lib/nscd.c --replace /usr/sbin/nscd ${glibc'.bin}/bin/nscd
  '';

  doCheck = true;
  nativeCheckInputs = [
    cmocka
  ];

  postInstall = ''
    # Move the su binary into the su package
    mkdir -p $su/bin
    mv $out/bin/su $su/bin
  '';

  enableParallelBuilding = true;

  disallowedReferences = lib.optional (
    stdenv.buildPlatform != stdenv.hostPlatform
  ) stdenv.shellPackage;

  meta = {
    homepage = "https://github.com/shadow-maint/shadow";
    description = "Suite containing authentication-related tools such as passwd and su";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ mdaniels5757 ];
    teams = [ lib.teams.security-review ];
    platforms = lib.platforms.linux;
    identifiers.cpeParts = lib.meta.cpeFullVersionWithVendor "shadow_project" finalAttrs.version;
  };

  passthru = {
    shellPath = "/bin/nologin";
    tests = { inherit (nixosTests) shadow; };
    # Package the upstream system test framework for use in nixosTests
    testFramework = stdenv.mkDerivation {
      name = "shadow-test-framework";
      inherit (finalAttrs) version;
      src = "${finalAttrs.src}/tests/system";
      installPhase = ''
        cp -r . $out/
      '';
      dontBuild = true;
      patches = [
        # tests: update useradd tests to expect ID 1001
        (fetchpatch {
          name = "update-useradd-tests.patch";
          url = "https://github.com/shadow-maint/shadow/commit/59fbe8415dab17f1e702fbdee96956886c86c737.patch";
          hash = "sha256-U0+NSCd4AfTuHMddTx9+wNtpdJt9t8+D5ApW0OCNgsY=";
          stripLen = 2;
        })
        # tests: update usermod tests to expect ID 1001
        (fetchpatch {
          name = "update-usermod-tests.patch";
          url = "https://github.com/shadow-maint/shadow/commit/91c2ad44ababca2e32cdb71152b0f7f2a7c546be.patch";
          hash = "sha256-v1EEvMfUYoE/ZnBM0k/+kUBK3W1dXr588OQzvFmnXLI=";
          stripLen = 2;
        })
        # tests: update groupadd tests to expect GID 1001
        (fetchpatch {
          name = "update-groupadd-tests.patch";
          url = "https://github.com/shadow-maint/shadow/commit/60568eaec13d1e417f56f0e59ac9573c0e3b9a83.patch";
          hash = "sha256-tLmGeW4Y7UcZqMhW3IXgygKPhCmbZkkW5XTJ7CFz9vg=";
          stripLen = 2;
        })
        # tests: update newgrp tests to expect GID 1002
        (fetchpatch {
          name = "update-newgrp-tests.patch";
          url = "https://github.com/shadow-maint/shadow/commit/49ff9bf33a7b6af57cb26688c3139f014302c9d9.patch";
          hash = "sha256-1760t4Ezd5Ke4PFZ70Njb+k+1kp17aT/7uqu1PswVss=";
          stripLen = 2;
        })
      ];
      postPatch = ''
        # Replace the gshadow existence check in the test framework with a more NixOS-friendly one, since NixOS does not have /etc/gshadow as a regular file
        substituteInPlace framework/hosts/shadow.py \
          --replace-fail 'getent gshadow > /dev/null 2>&1' 'test -f /etc/gshadow'

        # Remove the backup entry for gshadow, since it's not being used in the tests running on NixOS
        sed -i '/{"origin": "\/etc\/gshadow", "backup": "gshadow"}/d' framework/hosts/shadow.py

        # Replace the Debian-specific check in the useradd test with a NixOS-specific one
        substituteInPlace tests/test_useradd.py \
          --replace-fail 'if "Debian" in shadow.host.distro_name:' 'if "NixOS" in shadow.host.distro_name:'
      '';
    };
  };
})
