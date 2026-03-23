{
  lib,
  python3Packages,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  blueprint-compiler,
  desktop-file-utils,
  libadwaita,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "serigy";
  version = "2.0.0";
  pyproject = false; # uses meson

  src = fetchFromGitHub {
    owner = "CleoMenezesJr";
    repo = "Serigy";
    tag = finalAttrs.version;
    hash = "sha256-0Dc/Y0GYXMNFQ1rWCQaCZzN1Z8lMwdj0wO47pLUV5mM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    blueprint-compiler
    wrapGAppsHook4
    desktop-file-utils
    pkg-config
  ];

  buildInputs = [ libadwaita ];

  dependencies = with python3Packages; [ pygobject3 ];

  strictDeps = true;

  postInstallCheck = ''
    mesonCheckPhase
  '';

  dontWrapGApps = true;

  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/CleoMenezesJr/Serigy";
    description = "Store important information from your clipboard selectively and securely";
    mainProgram = "serigy";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
