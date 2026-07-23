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
  version = "1.12.3";

  src = fetchFromGitHub {
    owner = "proxytunnel";
    repo = "proxytunnel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+IRbL3VcnW+uYLIkwvaFJ8zBYbQAkqmzVluDsCrdURk=";
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
