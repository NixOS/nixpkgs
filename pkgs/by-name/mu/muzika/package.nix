{
  lib,
  desktop-file-utils,
  fetchFromGitHub,
  fetchYarnDeps,
  fixup-yarn-lock,
  gjs,
  glib-networking,
  gobject-introspection,
  gst_all_1,
  gtk4,
  libadwaita,
  libsoup_3,
  meson,
  ninja,
  pkg-config,
  stdenv,
  wrapGAppsHook4,
  yarn,
  nodejs,
  blueprint-compiler,
  libsecret,
}:

stdenv.mkDerivation rec {
  pname = "muzika";
  version = "unstable-2023-11-07";

  src = fetchFromGitHub {
    owner = "vixalien";
    repo = "muzika";
    rev = "69c25e066297c45f4ce42d84d5d4c200789fbedf";
    hash = "sha256-Uof72o6HG4pYj1KZ8KgCwQA+0m778ezZxmt3TohNZcY=";
    fetchSubmodules = true;
  };

  postPatch = ''
    # Remove git command from version query
    sed -i '2d' meson.build
  '';

  nativeBuildInputs = [
    blueprint-compiler
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    nodejs
    pkg-config
    fixup-yarn-lock
    wrapGAppsHook4
    yarn
  ];

  buildInputs = [
    gjs
    glib-networking
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-rs
    gtk4
    libadwaita
    libsecret
    libsoup_3
  ];

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-/NkLfBmQGvgufF9ajgs7DQsBkWUUK4Bslhy7VmCBrGg=";
  };

  preConfigure = ''
    export HOME="$PWD"
    yarn config --offline set yarn-offline-mirror $yarnOfflineCache
    fixup-yarn-lock yarn.lock
  '';

  mesonFlags = [
    "-Dyarnrc=../.yarnrc"
  ];

  postFixup = ''
    sed -i "1 a imports.package._findEffectiveEntryPointName = () => 'com.vixalien.muzika';" $out/bin/.com.vixalien.muzika-wrapped
    ln -s $out/bin/com.vixalien.muzika $out/bin/muzika
  '';

  meta = with lib; {
    description = "Elegant music streaming app";
    homepage = "https://github.com/vixalien/muzika";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ onny ];
  };
}
