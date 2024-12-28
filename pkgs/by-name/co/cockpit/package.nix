{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  bashInteractive,
  cacert,
  coreutils,
  dbus,
  docbook_xml_dtd_43,
  docbook_xsl,
  findutils,
  gettext,
  git,
  glib,
  glib-networking,
  gnused,
  gnutls,
  json-glib,
  krb5,
  libssh,
  libxcrypt,
  libxslt,
  makeWrapper,
  nodejs,
  nixosTests,
  nix-update-script,
  openssh,
  openssl,
  pam,
  pkg-config,
  polkit,
  python3Packages,
  runtimeShell,
  systemd,
  udev,
  xmlto,
}:

stdenv.mkDerivation rec {
  pname = "cockpit";
  version = "331";

  src = fetchFromGitHub {
    owner = "cockpit-project";
    repo = "cockpit";
    rev = "refs/tags/${version}";
    hash = "sha256-0iCFMwnPtbrCXZMQQB0C7xtvGHFLMPk8otgMrJmVxXw=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    autoreconfHook
    makeWrapper
    docbook_xml_dtd_43
    docbook_xsl
    findutils
    gettext
    git
    (lib.getBin libxslt)
    nodejs
    openssl
    pam
    pkg-config
    python3Packages.setuptools
    systemd
    xmlto
  ];

  buildInputs = [
    (lib.getDev glib)
    libxcrypt
    gnutls
    json-glib
    krb5
    libssh
    polkit
    udev
    python3Packages.pygobject3
    python3Packages.pip
  ];

  postPatch = ''
    # Instead of requiring Internet access to do an npm install to generate the package-lock.json
    # it copies the package-lock.json already present in the node_modules folder fetched as a git
    # submodule.
    echo "#!/bin/sh" > test/node_modules

    substituteInPlace src/tls/cockpit-certificate-helper.in \
      --replace 'COCKPIT_CONFIG="@sysconfdir@/cockpit"' 'COCKPIT_CONFIG=/etc/cockpit'

    substituteInPlace src/tls/cockpit-certificate-ensure.c \
      --replace '#define COCKPIT_SELFSIGNED_PATH      PACKAGE_SYSCONF_DIR COCKPIT_SELFSIGNED_FILENAME' '#define COCKPIT_SELFSIGNED_PATH      "/etc" COCKPIT_SELFSIGNED_FILENAME'

    substituteInPlace src/common/cockpitconf.c \
      --replace 'const char *cockpit_config_dirs[] = { PACKAGE_SYSCONF_DIR' 'const char *cockpit_config_dirs[] = { "/etc"'

    # instruct users with problems to create a nixpkgs issue instead of nagging upstream directly
    substituteInPlace configure.ac \
      --replace 'devel@lists.cockpit-project.org' 'https://github.com/NixOS/nixpkgs/issues/new?assignees=&labels=0.kind%3A+bug&template=bug_report.md&title=cockpit%25'

    patchShebangs \
      build.js \
      test/common/pixel-tests \
      test/common/run-tests \
      test/common/tap-cdp \
      tools/escape-to-c \
      tools/make-compile-commands \
      tools/node-modules \
      tools/termschutz \
      tools/webpack-make.js \
      tools/test-driver \
      test/common/static-code

    for f in node_modules/.bin/*; do
      patchShebangs $(realpath $f)
    done

    export HOME=$(mktemp -d)

    cp node_modules/.package-lock.json package-lock.json

    for f in pkg/**/*.js pkg/**/*.jsx test/**/* src/**/*; do
      # some files substituteInPlace report as missing and it's safe to ignore them
      substituteInPlace "$(realpath "$f")" \
        --replace '"/usr/bin/' '"' \
        --replace '"/bin/' '"' || true
    done

    substituteInPlace src/common/Makefile-common.am \
      --replace 'TEST_PROGRAM += test-pipe' "" # skip test-pipe because it hangs the build

    substituteInPlace src/ws/Makefile-ws.am \
      --replace 'TEST_PROGRAM += test-compat' ""

    substituteInPlace test/pytest/*.py \
      --replace "'bash" "'${bashInteractive}/bin/bash"

    echo "m4_define(VERSION_NUMBER, [${version}])" > version.m4

    # hardcode libexecdir, I am assuming that cockpit only use it to find it's binaries
    printf 'def get_libexecdir() -> str:\n\treturn "%s"' "$out/libexec" >> src/cockpit/packages.py
  '';

  configureFlags = [
    "--enable-prefix-only=yes"
    "--disable-pcp" # TODO: figure out how to package its dependency
    "--with-default-session-path=/run/wrappers/bin:/run/current-system/sw/bin"
    "--with-admin-group=root" # TODO: really? Maybe "wheel"?
  ];

  enableParallelBuilding = true;

  fixupPhase = ''
    runHook preFixup

    patchShebangs $out/libexec/*

    wrapProgram $out/libexec/cockpit-certificate-helper \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          openssl
        ]
      } \
      --run 'cd $(mktemp -d)'

    wrapProgram $out/bin/cockpit-bridge \
      --prefix PYTHONPATH : $out/${python3Packages.python.sitePackages}

    substituteInPlace $out/${python3Packages.python.sitePackages}/cockpit/_vendor/systemd_ctypes/libsystemd.py \
      --replace-fail libsystemd.so.0 ${systemd}/lib/libsystemd.so.0

    substituteInPlace $out/share/polkit-1/actions/org.cockpit-project.cockpit-bridge.policy \
      --replace-fail /usr $out

    substituteInPlace $out/lib/systemd/*/* \
      --replace /bin /run/current-system/sw/bin

    runHook postFixup
  '';

  checkInputs = [
    bashInteractive
    cacert
    dbus
    glib-networking
    openssh
    python3Packages.pytestCheckHook
  ];

  preCheck = ''
    export GIO_EXTRA_MODULES=$GIO_EXTRA_MODULES:${glib-networking}/lib/gio/modules
    export G_DEBUG=fatal-criticals
    export G_MESSAGES_DEBUG=cockpit-ws,cockpit-wrapper,cockpit-bridge
    export PATH=$PATH:$(pwd)

    # make pytest -j$NIX_BUILD_CORES || true
    make check  -j$NIX_BUILD_CORES || true
    npm run eslint
    npm run stylelint
  '';

  passthru = {
    tests = { inherit (nixosTests) cockpit; };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Web-based graphical interface for servers";
    mainProgram = "cockpit-bridge";
    homepage = "https://cockpit-project.org/";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ lucasew ];
  };
}
