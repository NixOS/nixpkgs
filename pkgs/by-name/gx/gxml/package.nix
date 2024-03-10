{ stdenv
, lib
, fetchFromGitLab
, gobject-introspection
, meson
, ninja
, pkg-config
, vala
, glib
, libgee
, libxml2
, gitUpdater
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gxml";
  version = "0.20.3";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gxml";
    rev = finalAttrs.version;
    hash = "sha256-GlctGxsLyQ2kPV3oBmusRiouG4PPncBTh3vgxhVaQOo=";
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
    substituteInPlace gxml/gxml.pc.in \
      --replace-fail "includedir=@prefix@/include" "includedir=${placeholder "dev"}/include"
  '';

  doCheck = true;

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "GXml provides a GObject API for manipulating XML and a Serializable framework from GObject to XML";
    homepage = "https://gitlab.gnome.org/GNOME/gxml";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jmarmstrong1207 ] ++ teams.gnome.members;
  };
})
