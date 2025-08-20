{
  lib,
  stdenv,
  fetchFromGitLab,
  appstream,
  blueprint-compiler,
  desktop-file-utils,
  gjs,
  gst_all_1,
  libadwaita,
  meson,
  ninja,
  pkg-config,
  typescript,
  wrapGAppsHook4,
  nix-update-script,
}:
stdenv.mkDerivation rec {
  pname = "decibels";
  version = "46.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "GNOME";
    owner = "Incubator";
    repo = "decibels";
    rev = version;
    hash = "sha256-3LQQcrpmWrTfk8A8GR+KnxJEB1HGozgEsM+j5ECK8kc=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    appstream
    blueprint-compiler
    desktop-file-utils
    meson
    ninja
    pkg-config
    typescript
    wrapGAppsHook4
  ];

  buildInputs = [
    gjs
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base # for GstVideo
    gst_all_1.gst-plugins-bad # for GstPlay
    gst_all_1.gst-plugins-good # for scaletempo
    gst_all_1.gst-libav
    libadwaita
  ];

  # NOTE: this is applied after install to ensure `tsc` doesn't
  # mess with us
  #
  # gjs uses the invocation name to add gresource files
  # to get around this, we set the entry point name manually
  preFixup = ''
    sed -i "1 a imports.package._findEffectiveEntryPointName = () => 'org.gnome.Decibels';" $out/bin/org.gnome.Decibels
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Play audio files";
    homepage = "https://gitlab.gnome.org/GNOME/Incubator/decibels";
    changelog = "https://gitlab.gnome.org/GNOME/Incubator/decibels/-/blob/main/NEWS?ref_type=tags";
    license = lib.licenses.gpl3Only;
    maintainers = lib.teams.gnome-circle.members;
    mainProgram = "org.gnome.Decibels";
    platforms = lib.platforms.linux;
  };
}
