{
  appstream,
  desktop-file-utils,
  fetchFromGitLab,
  lib,
  libadwaita,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  stdenv,
  vala,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "palette";
  version = "3.0.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "design";
    repo = "palette";
    tag = finalAttrs.version;
    hash = "sha256-DfLK5a2wJnwC8N90qOjSDNpMbM0jpauGTlgDwjQ5+kU=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    appstream
    desktop-file-utils
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    libadwaita
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Colour Palette tool";
    homepage = "https://gitlab.gnome.org/World/design/palette";
    license = lib.licenses.gpl3Only;
    mainProgram = "org.gnome.design.Palette";
    maintainers = with lib.maintainers; [ hythera ];
    platforms = lib.platforms.linux;
  };
})
