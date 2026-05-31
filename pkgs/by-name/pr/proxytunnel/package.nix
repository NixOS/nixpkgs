{
  lib,
  stdenv,
  openssl,
  fetchFromGitHub,
  versionCheckHook,
  asciidoc,
  xmlto,
  docbook-xsl-nons,
  docbook_xml_dtd_45,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "proxytunnel";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "proxytunnel";
    repo = "proxytunnel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4+EGVtohM0vL/fXHCXohwWqIBTiIUGbt6AZ7JKpRCT8=";
  };

  makeFlags = [ "prefix=${placeholder "out"}" ];
  buildInputs = [ openssl ];
  nativeBuildInputs = [
    asciidoc
    xmlto
    docbook-xsl-nons
    docbook_xml_dtd_45
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    mainProgram = "proxytunnel";
    homepage = "http://proxytunnel.sf.net/";
    description = "Stealth tunneling through HTTP(S) proxies";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Only;
    changelog = "https://github.com/proxytunnel/proxytunnel/raw/${finalAttrs.src.tag}/CHANGES";
    maintainers = with lib.maintainers; [
      lenianiva
    ];
  };
})
