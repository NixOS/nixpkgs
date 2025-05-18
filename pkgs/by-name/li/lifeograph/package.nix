{
  lib,
  stdenv,
  fetchgit,
  pkg-config,
  meson,
  ninja,
  wrapGAppsHook4,
  enchant,
  gtkmm4,
  libchamplain,
  libgcrypt,
  shared-mime-info,
  libshumate,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lifeograph";
  version = "3.0.1";

  src = fetchgit {
    url = "https://git.launchpad.net/lifeograph";
    rev = "v${finalAttrs.version}";
    hash = "sha256-tcq1A1P8sJ57Tr2MLxsFIru+VJdORuvPBq6fMgBmuY0=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    shared-mime-info # for update-mime-database
    wrapGAppsHook4
  ];

  buildInputs = [
    libgcrypt
    enchant
    gtkmm4
    libchamplain
    libshumate
  ];

  postInstall = ''
    substituteInPlace $out/share/applications/net.sourceforge.Lifeograph.desktop \
      --replace-fail "Exec=" "Exec=$out/bin/"
  '';

  meta = {
    homepage = "https://lifeograph.sourceforge.net/doku.php?id=start";
    description = "Off-line and private journal and note taking application";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ emaryn ];
    mainProgram = "lifeograph";
    platforms = lib.platforms.linux;
  };
})
