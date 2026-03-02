{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  python3,
  xmlbird,
  cairo,
  gdk-pixbuf,
  libgee,
  glib,
  gtk3,
  webkitgtk_4_1,
  libnotify,
  sqlite,
  vala,
  gobject-introspection,
  gsettings-desktop-schemas,
  wrapGAppsHook3,
  autoPatchelfHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "birdfont";
  version = "2.33.6-unstable-2025-11-23"; # For gcc15 error fix, remove unstable versioning in next release

  src = fetchFromGitHub {
    owner = "johanmattssonm";
    repo = "birdfont";
    rev = "9865e6611e0bf00cbc5742ae1aab6eca4d04f072";
    hash = "sha256-ZKnMBLjjoEHGKWGT3gJZ2BId48rOAYjygv3JeS9VKro=";
  };

  nativeBuildInputs = [
    python3
    pkg-config
    vala
    gobject-introspection
    wrapGAppsHook3
    autoPatchelfHook
  ];
  buildInputs = [
    xmlbird
    libgee
    cairo
    gdk-pixbuf
    glib
    gtk3
    webkitgtk_4_1
    libnotify
    sqlite
    gsettings-desktop-schemas
  ];

  postPatch = ''
    substituteInPlace install.py \
      --replace 'platform.version()' '"Nix"'

    patchShebangs .
  '';

  buildPhase = "./build.py";

  installPhase = "./install.py";

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version=branch" ];
    };
  };

  meta = {
    description = "Font editor which can generate fonts in TTF, EOT, SVG and BIRDFONT format";
    homepage = "https://birdfont.org";
    license = lib.licenses.gpl3;
    maintainers = [ ];
  };
})
