{ stdenv, fetchurl, fetchpatch, fetchFromGitLab, meson, ninja, gettext, cargo, rustc, python3, rustPlatform, pkgconfig, gnome3
, glib, libhandy, gtk3, dbus, openssl, sqlite, gst_all_1, wrapGAppsHook }:

# TODO: build from git for easier updates
# rustPlatform.buildRustPackage rec {
stdenv.mkDerivation rec {
  version = "0.4.6";
  name = "gnome-podcasts-${version}";

  src = fetchurl {
    url = https://gitlab.gnome.org/World/podcasts/uploads/e59ac5d618d7daf4c7f33ba72957c466/gnome-podcasts-0.4.6.tar.xz;
    sha256 = "0g2rk3w251fp5jwbxs5ya1adv8nsgdqjy1vmfg8qqab6qyndhbrc";
  };

  patches = [
    # podcasts-data would fail to build because it errors on warnings
    (fetchpatch {
      url = "https://gitlab.gnome.org/World/podcasts/commit/7dc1b25ee7fc59a188312d31b1fa00c3110ae63e.patch";
      sha256 = "03ibbh1snk1391vnni529agqs14lzg5g0axjgpf3gn8dwwh1yvd5";
    })
  ];

  # src = fetchFromGitLab {
  #   domain = "gitlab.gnome.org";
  #   owner = "World";
  #   repo = "podcasts";
  #   rev = version;
  #   sha256 = "15xj98dhxvys0cnya9488qsfsm0ys1wy69wkc39z8j6hwdm7byq2";
  # };

  nativeBuildInputs = [
    meson ninja pkgconfig gettext cargo rustc python3 wrapGAppsHook
  ];
  buildInputs = [
    glib gtk3 libhandy dbus openssl sqlite gst_all_1.gstreamer gst_all_1.gst-plugins-base gst_all_1.gst-plugins-bad
  ];

  # cargoSha256 = "0721b5f700vvvzvmdl8nfjaa6j412q1fjssgrjv8n6rmn9z13d2v";

  postPatch = ''
    chmod +x scripts/compile-gschema.py # patchShebangs requires executable file
    patchShebangs scripts/compile-gschema.py
  '';

  meta = with stdenv.lib; {
    description = "Listen to your favorite podcasts";
    homepage = https://wiki.gnome.org/Apps/Podcasts;
    license = licenses.gpl3;
    maintainers = gnome3.maintainers;
    platforms = platforms.unix;
  };
}
