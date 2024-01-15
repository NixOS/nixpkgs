{ lib
, stdenv
, fetchFromGitHub
, appstream-glib
, blueprint-compiler
, desktop-file-utils
, gettext
, gtk4
, libadwaita
, meson
, ninja
, pkg-config
, python3
, wrapGAppsHook4
, zint
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "passes";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "pablo-s";
    repo = "passes";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RfoqIyqc9zwrWZ5RLhQl+6vTccbCTwtDcMlnWPCDOag=";
  };

  postPatch = ''
    substituteInPlace src/model/meson.build \
      --replace /app/lib ${zint}/lib
    substituteInPlace src/view/window.blp \
      --replace reveal_flap reveal-flap
    substituteInPlace build-aux/meson/postinstall.py \
      --replace gtk-update-icon-cache gtk4-update-icon-cache
    patchShebangs build-aux/meson/postinstall.py
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
    (python3.withPackages (pp: [pp.pygobject3]))
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    zint
  ];

  meta = with lib; {
    description = "A digital pass manager";
    homepage = "https://github.com/pablo-s/passes";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
    broken = stdenv.isDarwin; # Crashes
  };
})
