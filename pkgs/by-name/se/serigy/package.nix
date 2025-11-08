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

python3Packages.buildPythonApplication rec {
  pname = "serigy";
  version = "1.1";
  pyproject = false; # uses meson

  src = fetchFromGitHub {
    owner = "CleoMenezesJr";
    repo = "Serigy";
    tag = version;
    hash = "sha256-1PlGR7aX7Ekrbe7+Qm0E1h6yl6CzdIcV2R3MSIIeH6o=";
  };

  postPatch = ''
    substituteInPlace src/setup_dialog.py \
      --replace-fail "flatpak run io.github.cleomenezesjr.Serigy" "serigy"
  '';

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
}
