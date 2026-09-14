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
  version = "0.12";

  src = fetchFromGitHub {
    owner = "pablo-s";
    repo = "passes";
    rev = "v${finalAttrs.version}";
    hash = "sha256-S+TEZQu7Ye+hBqzSJP/YEik35b+4LQrnk2A/hhTjpww=";
  };

  postPatch = ''
    substituteInPlace src/model/meson.build \
      --replace-fail /app/lib ${lib.getLib libzint}/lib

    substituteInPlace ./src/meson.build \
      --replace-fail "conf.set('PYTHON', python.find_installation('python3').full_path())" "conf.set('PYTHON', '${
        lib.getExe (python3.withPackages (pp: [ pp.pygobject3 ]))
      }')"
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
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    libzint
  ];

  meta = {
    description = "Digital pass manager";
    mainProgram = "passes";
    homepage = "https://github.com/pablo-s/passes";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isDarwin; # Crashes
  };
})
