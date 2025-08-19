{
  lib,
  stdenv,
  fetchFromGitHub,
  appstream-glib,
  blueprint-compiler,
  desktop-file-utils,
  gettext,
  gtk4,
  libadwaita,
  meson,
  ninja,
  pkg-config,
  python3,
  wrapGAppsHook4,
  libzint,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "passes";
  version = "0.10";

  src = fetchFromGitHub {
    owner = "pablo-s";
    repo = "passes";
    rev = "v${finalAttrs.version}";
    hash = "sha256-e6nHCOrb2PX47REr7sy80n1aTdMZ0c2QZlIIib4vll8=";
  };

  postPatch = ''
    substituteInPlace src/model/meson.build \
      --replace-fail /app/lib ${lib.getLib libzint}/lib
  '';

  strictDeps = true;

  nativeBuildInputs = [
    appstream-glib
    blueprint-compiler
    desktop-file-utils
    gettext
    meson
    ninja
    pkg-config
    (python3.withPackages (pp: [ pp.pygobject3 ]))
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    libzint
  ];

  meta = with lib; {
    description = "Digital pass manager";
    mainProgram = "passes";
    homepage = "https://github.com/pablo-s/passes";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
    broken = stdenv.hostPlatform.isDarwin; # Crashes
  };
})
