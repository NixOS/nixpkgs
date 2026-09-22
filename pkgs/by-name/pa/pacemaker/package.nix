{
  lib,
  stdenv,
  autoconf,
  automake,
  bash,
  bzip2,
  corosync,
  dbus,
  docbook_xsl,
  fetchFromGitHub,
  getopt,
  gettext,
  glib,
  gnutls,
  help2man,
  libqb,
  libtool,
  libuuid,
  libxml2,
  libxslt,
  pam,
  pkg-config,
  python3,
  nixosTests,
  versionCheckHook,

  # Pacemaker is compiled twice, once with forOCF = true to extract its
  # OCF definitions for use in the ocf-resource-agents derivation, then
  # again with forOCF = false, where the ocf-resource-agents is provided
  # as the OCF_ROOT.
  forOCF ? false,
  ocf-resource-agents,
  withManpages ? !forOCF,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pacemaker";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "ClusterLabs";
    repo = "pacemaker";
    tag = "Pacemaker-${finalAttrs.version}";
    hash = "sha256-23YkNzqiimLy/KjO+hxVQQ4rUhSEhn5Oc2jUJO/VRo0=";
  };

  outputs = [ "out" ] ++ lib.optionals withManpages [ "man" ];

  nativeBuildInputs = [
    autoconf
    automake
    gettext
    getopt
    libtool
    pkg-config
    python3
  ]
  ++ lib.optionals withManpages [
    # If we don't supply the dependencies the manpage build will be silently skipped
    help2man # for tool man pages (see mk/man.mk)
    libxml2 # for other man pages (xmllint)
    libxslt # for other man pages (xsltproc)
  ];

  buildInputs = [
    bash
    bzip2
    corosync
    dbus
    glib
    gnutls
    libqb
    libtool
    libuuid
    libxml2
    libxslt
    pam
  ];

  strictDeps = true;

  # If we do this unconditionally the build will fail because it sees a valid MANPAGE_XSLT
  # but required executables are not available.
  postPatch = lib.optionalString withManpages ''
    # Avoid the use of xmlcatalog to resolve stylesheet for manpages, but set the path directly
    substituteInPlace configure.ac \
      --replace-fail 'MANPAGE_XSLT=""' 'MANPAGE_XSLT="${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl"' \
      --replace-fail 'AS_IF([test x"''${XSLTPROC}" != x""],' 'AS_IF([false],'
  '';

  preConfigure = ''
    ./autogen.sh --prefix="$out"
  '';
  configureFlags = [
    "--exec-prefix=${placeholder "out"}"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-initdir=/etc/systemd/system"
    "--with-systemdsystemunitdir=/etc/systemd/system"
    "--with-corosync"
    # allows Type=notify in the systemd service
    "--enable-systemd"
  ]
  ++ lib.optional (!forOCF) "--with-ocfdir=${ocf-resource-agents}/usr/lib/ocf";

  installFlags = [ "DESTDIR=${placeholder "out"}" ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isGNU [
      "-Wno-error=strict-prototypes"
      "-Wno-error=deprecated-declarations"
    ]
  );

  enableParallelBuilding = true;

  # pacemaker's install linking requires a weirdly nested hierarchy
  postInstall =
    lib.optionalString withManpages ''
      mkdir -p $man
      mv $out$man/* $man
    ''
    + ''
      mv $out$out/* $out
      rm -r $out/nix
    '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = [ "${placeholder "out"}/sbin/pacemakerd" ];
  versionCheckProgramArg = "--version";

  passthru.tests = {
    inherit (nixosTests) pacemaker;
  };

  meta = {
    homepage = "https://clusterlabs.org/pacemaker/";
    description = "Open source, high availability resource manager suitable for both small and large clusters";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      ryantm
      astro
    ];
  };
})
