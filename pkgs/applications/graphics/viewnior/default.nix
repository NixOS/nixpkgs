{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  meson,
  ninja,
  pkg-config,
  desktop-file-utils,
  gtk2,
  libpng,
  exiv2,
  lcms,
  intltool,
  gettext,
  shared-mime-info,
  glib,
  gdk-pixbuf,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "viewnior";
  version = "1.8";

  src = fetchFromGitHub {
    owner = "hellosiyan";
    repo = "Viewnior";
    rev = "${pname}-${version}";
    hash = "sha256-LTahMmcAqgqviUxR624kTozJGTniAAGWKo1ZqXjoG5M=";
  };

  patches = [
    (fetchpatch {
      name = "viewnior-1.8-change-exiv2-AutoPtr-to-unique_ptr.patch";
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-gfx/viewnior/files/viewnior-1.8-change-exiv2-AutoPtr-to-unique_ptr.patch?id=002882203ad6a2b08ce035a18b95844a9f4b85d0";
      hash = "sha256-O3/d7qMiOsYJmz7ekoLM6oaHcuYjEbAfPFuDUWSybfE=";
    })
    (fetchpatch {
      name = "viewnior-1.8-add-support-for-exiv-0.28.0-errors.patch";
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-gfx/viewnior/files/viewnior-1.8-add-support-for-exiv-0.28.0-errors.patch?id=002882203ad6a2b08ce035a18b95844a9f4b85d0";
      hash = "sha256-Zjc4CIlelAkbyvX2F1yo/qJjUajtAgF4+FoHWFEIPWY=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    desktop-file-utils
    intltool
    gettext
  ];

  buildInputs = [
    gtk2
    libpng
    exiv2
    lcms
    shared-mime-info
    glib
    gdk-pixbuf
    perl
  ];

  meta = with lib; {
    description = "Fast and simple image viewer";
    longDescription = ''
      Viewnior is insipred by big projects like Eye of Gnome, because of it's
              usability and richness,and by GPicView, because of it's lightweight design and
              minimal interface. So here comes Viewnior - small and light, with no compromise
              with the quality of it's functions. The program is made with better integration
              in mind (follows Gnome HIG2).
    '';
    license = licenses.gpl3;
    homepage = "https://siyanpanayotov.com/project/viewnior/";
    maintainers = with maintainers; [
      smironov
      artturin
    ];
    platforms = platforms.gnu ++ platforms.linux;
    mainProgram = "viewnior";
  };
}
