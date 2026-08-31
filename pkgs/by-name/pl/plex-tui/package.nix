{
  lib,
  fetchFromGitHub,
  makeWrapper,
  mpv,
  python3Packages,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "plex-tui";
  version = "0.17.29";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "so1omon563";
    repo = "plex-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J0DqZ0SoPep2MUkm/JnKkxjdteZwZJXWnvGMYeNYh/E=";
  };

  nativeBuildInputs = [ makeWrapper ];

  build-system = [ python3Packages.hatchling ];

  dependencies = with python3Packages; [
    pillow
    platformdirs
    plexapi
    textual
  ];

  nativeCheckInputs = [ versionCheckHook ];

  pythonImportsCheck = [ "plextui" ];

  postFixup = ''
    wrapProgram $out/bin/plex-tui \
      --prefix PATH : ${lib.makeBinPath [ mpv ]}
  '';

  meta = {
    description = "Terminal UI for browsing and playing media from Plex";
    homepage = "https://github.com/so1omon563/plex-tui";
    changelog = "https://github.com/so1omon563/plex-tui/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ so1omon563 ];
    mainProgram = "plex-tui";
  };
})
