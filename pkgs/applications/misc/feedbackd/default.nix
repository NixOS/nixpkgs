{ lib
, stdenv
, fetchFromGitLab
, docbook-xsl-nons
, gobject-introspection
, gtk-doc
, libxslt
, meson
, ninja
, pkg-config
, vala
, wrapGAppsHook
, glib
, gsound
, json-glib
, libgudev
, dbus
}:

let
  themes = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = "feedbackd-device-themes";
    rev = "v0.0.20220523";
    sha256 = "sha256-RyUZj+tpJSYhyoK+E98CTIoHwXwBdB1YHVnO5821exo=";
  };
in
stdenv.mkDerivation rec {
  pname = "feedbackd";
  # Not an actual upstream project release,
  # only a Debian package release that is tagged in the upstream repo
  version = "0.0.0+git20220520";

  outputs = [ "out" "dev" ]
    # remove if cross-compiling gobject-introspection works
    ++ lib.optionals (stdenv.buildPlatform == stdenv.hostPlatform) [ "devdoc" ];

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = "feedbackd";
    rev = "v${version}";
    hash = "sha256-4ftPC6LnX0kKFYVyH85yCH43B3YjuaZM5rzr8TGgZvc=";
  };

  nativeBuildInputs = [
    docbook-xsl-nons
    gobject-introspection
    gtk-doc
    libxslt
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gsound
    json-glib
    libgudev
  ];

  mesonFlags = [
    "-Dgtk_doc=${lib.boolToString (stdenv.buildPlatform == stdenv.hostPlatform)}"
    "-Dman=true"
    # TODO(mindavi): introspection broken due to https://github.com/NixOS/nixpkgs/issues/72868
    #                can be removed if cross-compiling gobject-introspection works.
    "-Dintrospection=${if (stdenv.buildPlatform == stdenv.hostPlatform) then "enabled" else "disabled"}"
  ];

  checkInputs = [
    dbus
  ];

  doCheck = true;

  postInstall = ''
    mkdir -p $out/lib/udev/rules.d
    sed "s|/usr/libexec/|$out/libexec/|" < $src/debian/feedbackd.udev > $out/lib/udev/rules.d/90-feedbackd.rules
    cp ${themes}/data/* $out/share/feedbackd/themes/
  '';

  meta = with lib; {
    description = "A daemon to provide haptic (and later more) feedback on events";
    homepage = "https://source.puri.sm/Librem5/feedbackd";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pacman99 tomfitzhenry ];
    platforms = platforms.linux;
  };
}
