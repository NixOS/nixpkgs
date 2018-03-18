{ stdenv, fetchFromGitHub, fetchpatch, pkgconfig, boost, dbus-glib, gnome3
, xorg, help2man, intltool, libsigcxx, wrapGAppsHook}:

stdenv.mkDerivation rec {
  name = "easystroke-${version}";
  version = "unstable-2016-07-05";

  src = fetchFromGitHub {
    owner = "thjaeger";
    repo = "easystroke";
    rev = "f7c1614004e9c518bd4f6f4b3a2ddaf23911a5ef";
    sha256 = "0map8zbnq993gchgw97blf085cbslry2sa3z4ambdcwbl0r9rd6x";
  };

  nativeBuildInputs = [ help2man intltool pkgconfig wrapGAppsHook ];
  buildInputs = [
    boost dbus-glib gnome3.defaultIconTheme gnome3.gtkmm libsigcxx
    xorg.xorgproto xorg.libXtst xorg.xorgserver
  ];

  patches = [
    # Upstream development has ceased and some patches are now required to fix the build and avoid crashes:
    # https://web.archive.org/web/20181217031130/https://github.com/thjaeger/easystroke/wiki/BuildInstructions#Releases
    #
    # See also https://github.com/thjaeger/easystroke/pull/10#issuecomment-444132355

    (fetchpatch {
      # Fix build failure with libsignc++ version 2.5.1 or newer
      url = https://github.com/thjaeger/easystroke/commit/22b28d25bb696e37e73b4bc641439b3db9f564ed.patch;
      sha256 = "0dbsbvwqb9fmpihg86an5xmpq5is5721pdgw5hps06801vy5yg58";
    })
    (fetchpatch {
      # Remove abs(float) function that clashes with std::abs(float)
      url = https://github.com/thjaeger/easystroke/commit/9e2c32390c5c253aade3bb703e51841748d2c37e.patch;
      sha256 = "1z6hhh7qvzfvryjiwxg2ki4xx00b53f3vha5amqc6bhyajndxpk4";
    })
    (fetchpatch {
      # Fix recurring crash when trying to render 0x0 tray icon
      url = https://github.com/thjaeger/easystroke/commit/140b9cae66ba874bf0994eea71210baf417a136e.patch;
      sha256 = "1pjxpmimi82qzcxpf8yjip7acylpvgayrm7i1wpk386wkrdlglsn";
    })
    (fetchpatch {
      # Don't ignore xshape setting when saving; fixes https://bugs.launchpad.net/ubuntu/+source/easystroke/+bug/1728746
      name = "dont-ignore-xshape-when-saving.patch";
      url = https://aur.archlinux.org/cgit/aur.git/plain/dont-ignore-xshape-when-saving.patch?h=easystroke-git&id=fcd9c1080cddbabae3e85a2f6d8c8be5c2b7c13d;
      sha256 = "0br37pn1ii46qz08rkprhaxq0s480h3vybc1q2sgym32wq7fv375";
    })
    (fetchpatch {
      # Switch from fork to g_spawn_async; fixes zombie process bug
      url = https://github.com/thjaeger/easystroke/commit/0e60f1630fc6267fcaf287afef3f8c5eaafd3dd9.patch;
      sha256 = "0jsj6nrkv69ncz9lyjw9pvc2pyk3zp7gjflmvmb6pkq8dxqhj3lg";
    })
    (fetchpatch {
      # Add tray icon option to toggle easystroke on/off
      name = "add-toggle-option.patch";
      url = https://aur.archlinux.org/cgit/aur.git/plain/add-toggle-option.patch?h=easystroke-git&id=fcd9c1080cddbabae3e85a2f6d8c8be5c2b7c13d;
      sha256 = "02bfd3bfvg7awid4l46jslwsqab7kc01gkjg8vfpjvb2h4aak30i";
    })
  ];

  buildFlags = [ "all" "man" ];

  installFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    install -D -m 644 easystroke.1 $out/share/man/man1/easystroke.1
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/thjaeger/easystroke/wiki;
    description = "X11 gesture recognition application";
    license = licenses.isc;
    maintainers = with maintainers; [ ivan ];
    platforms = platforms.linux;
    knownVulnerabilities = [
      "Unmaintained upstream"
      "Crashes Xorg once every few thousand strokes"
    ];
  };
}
