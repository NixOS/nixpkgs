{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  nix-update-script,
  pkg-config,
  ding-libs,
  krb5,
  libverto,
  popt,
  libxml2,
  libxslt,
  docbook-xsl-nons,
  docbook_xml_dtd_44,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gssproxy";
  version = "0.9.2";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "gssapi";
    repo = "gssproxy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RcT1ge/XxhTaT9hrvcHElAEAbvOtjqep3kdEw5e7WZY=";
  };

  nativeBuildInputs = [
    autoreconfHook
    docbook-xsl-nons
    docbook_xml_dtd_44
    libxml2
    libxslt
    pkg-config
  ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  makeFlags = [
    "SGML_CATALOG_FILES=${docbook-xsl-nons}/xml/xsl/docbook/catalog.xml ${docbook_xml_dtd_44}/xml/dtd/docbook/catalog.xml"
    "VERTO_CFLAGS=${libverto}/include"
    "VERTO_LIBS=${libverto}/lib/libverto.so"
  ];

  postInstall = ''
    find $out -type d -empty -delete
  '';

  buildInputs = [
    ding-libs
    krb5
    libverto
    popt
  ];

  configureFlags = [
    "--with-pubconf-path=${placeholder "out"}/etc/gssproxy"
    "--with-initscript=none"
    "--without-selinux"
    # Use REMOTE_FIRST behavior: try gssproxy daemon first, fall back to local credentials
    "--with-gpp-default-behavior=REMOTE_FIRST"
    "--with-xml-catalog-path=${docbook-xsl-nons}/xml/xsl/docbook/catalog.xml"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GSS-API proxy client library for credential isolation";
    homepage = "https://github.com/gssapi/gssproxy";
    changelog = "https://github.com/gssapi/gssproxy/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jlesquembre ];
    mainProgram = "gssproxy";
    platforms = lib.platforms.all;
  };
})
