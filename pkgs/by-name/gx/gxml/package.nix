{
  stdenv,
  lib,
  fetchFromGitLab,
  gobject-introspection,
  meson,
  ninja,
  pkg-config,
  vala,
  glib,
  libgee,
  libxml2,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gxml";
  version = "0.20.4";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gxml";
    rev = finalAttrs.version;
    hash = "sha256-/gaWuUytBsvAsC95ee6MtTW6g3ltGbkD+JWqrAjJLDc=";
  };

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    pkg-config
    vala
  ];

  propagatedBuildInputs = [
    glib
    libgee
    libxml2
  ];

  postPatch = ''
    # https://gitlab.gnome.org/GNOME/gxml/-/merge_requests/24
    # https://gitlab.gnome.org/GNOME/gxml/-/merge_requests/28
    substituteInPlace gxml/gxml.pc.in \
      --replace-fail "includedir=@prefix@/include" "includedir=${placeholder "dev"}/include" \
      --replace-fail ">=2" ">= 2" \
      --replace-fail ">=0" ">= 0"
  '';

  # https://github.com/NixOS/nixpkgs/issues/407969
  doCheck = false;

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Provides a GObject API for manipulating XML and a Serializable framework from GObject to XML";
    homepage = "https://gitlab.gnome.org/GNOME/gxml";
    changelog = "https://gitlab.gnome.org/GNOME/gxml/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jmarmstrong1207 ];
    teams = [ teams.gnome ];
  };
})
