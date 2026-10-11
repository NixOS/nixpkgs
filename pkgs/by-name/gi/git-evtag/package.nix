{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  libxslt,
  docbook-xsl-nons,
  docbook_xml_dtd_42,
  glib,
  libgit2,
  gitUpdater,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "git-evtag";
  version = "2022.1";

  src = fetchFromGitHub {
    owner = "cgwalters";
    repo = "git-evtag";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+nGPfISDpf2YMeCtPgaOOwzYijTPGRVCzT+74sGZ3JY=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    # Man page
    libxslt
    docbook-xsl-nons
    docbook_xml_dtd_42
  ];

  buildInputs = [
    glib
    libgit2
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;

  versionCheckProgramArg = "--version";

  passthru = {
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Extended verification for git tags";
    homepage = "https://github.com/cgwalters/git-evtag";
    changelog = "https://github.com/cgwalters/git-evtag/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ jtojnar ];
    mainProgram = "git-evtag";
    platforms = lib.platforms.unix;
  };
})
