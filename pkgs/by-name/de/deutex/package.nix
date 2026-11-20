{
  lib,
  stdenv,
  fetchFromGitHub,
  asciidoc,
  autoreconfHook,
  docbook_xml_dtd_45,
  docbook_xsl,
  libpng,
  libxml2,
  libxslt,
  nix-update-script,
  pkg-config,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "deutex";
  version = "5.2.3";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Doom-Utils";
    repo = "deutex";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wDAlwOtupkYv6y4fQPwL/PVOhh7wqORnjxV22kmON+U=";
  };

  nativeBuildInputs = [
    # a2x, for the man page
    asciidoc
    docbook_xml_dtd_45
    docbook_xsl
    libxml2
    libxslt

    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libpng
  ];

  configureFlags = [
    (lib.enableFeature true "man")
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line tool to create and modify WAD files for games built on the original Doom engine";
    homepage = "https://github.com/Doom-Utils/deutex";
    changelog = "https://github.com/Doom-Utils/deutex/blob/${finalAttrs.src.tag}/NEWS.adoc";
    license = with lib.licenses; [
      gpl2Plus
      hpnd
      lgpl21Plus
    ];
    maintainers = with lib.maintainers; [
      keenanweaver
      thetaoofsu
    ];
    platforms = lib.platforms.unix;
    mainProgram = "deutex";
  };
})
