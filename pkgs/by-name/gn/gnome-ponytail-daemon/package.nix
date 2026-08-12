{
  lib,
  stdenv,
  fetchFromGitLab,

  glib,
  meson,
  ninja,
  pkg-config,

  systemd,
  libei,
  libxkbcommon,

  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-ponytail-daemon";
  version = "0.0.11";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "ofourdan";
    repo = "gnome-ponytail-daemon";
    tag = finalAttrs.version;
    hash = "sha256-AHLopvrnE8DK0rNkAw2pEIwGb9WPHjSM/jiYRCRliOc=";
  };

  buildInputs = [
    glib
    systemd
    libei
    libxkbcommon
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  propagatedBuildInputs = with python3.pkgs; [
    dbus-python
    pygobject3
  ];

  postPatch = ''
    # Prevent Meson from trying to install the systemd service into the read-only systemd package store path.
    # We redirect it to the derivation's $out/lib/systemd/user instead.
    for file in meson.build src/meson.build; do
      if [ -f "$file" ]; then
        sed -i "s|systemd_dep.get_pkgconfig_variable('systemduserunitdir')|join_paths(get_option('prefix'), 'lib', 'systemd', 'user')|g" "$file"
      fi
    done
  '';

  meta = {
    description = "A daemon to provide screen casting and remote desktop for testing";
    homepage = "https://gitlab.gnome.org/ofourdan/gnome-ponytail-daemon";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ phanirithvij ];
    mainProgram = "gnome-ponytail-daemon";
    platforms = lib.platforms.linux;
  };
})
