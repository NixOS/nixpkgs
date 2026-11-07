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
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "typography";
  version = "0.3.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "design";
    repo = "typography";
    tag = finalAttrs.version;
    hash = "sha256-XAoqB3Gvd/sRrbM4m5s3aYia7bZgPB9UEJ26Bzkj8Ws=";
    forceFetchGit = true;
  };

  nativeBuildInputs = [
    appstream
    desktop-file-utils
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libadwaita
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for looking up text styles";
    homepage = "https://gitlab.gnome.org/World/design/typography";
    license = lib.licenses.gpl3Only;
    mainProgram = "org.gnome.design.Typography";
    maintainers = with lib.maintainers; [ hythera ];
    platforms = lib.platforms.linux;
  };
})
