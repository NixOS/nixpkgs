{ stdenv, fetchurl, pkgconfig
, flex, bison, gettext
, xineUI, wxSVG
, fontconfig
, xmlto, docbook5, zip
, cdrtools, dvdauthor, dvdplusrwtools
, dvdisasterSupport ? true, dvdisaster ? null
, thumbnailSupport ? true, libgnomeui ? null
, udevSupport ? true, libudev ? null
, dbusSupport ? true, dbus ? null
, makeWrapper }:

with stdenv.lib;
stdenv.mkDerivation rec {

  name = "dvdstyler-${version}";
  srcName = "DVDStyler-${version}";
  version = "3.0.4";

  src = fetchurl {
    url = "mirror://sourceforge/project/dvdstyler/dvdstyler/${version}/${srcName}.tar.bz2";
    sha256 = "0lwc0hn94m9r8fi07sjqz3fr618l6lnw3zsakxw7nlgnxbjsk7pi";
  };

  nativeBuildInputs = 
  [ pkgconfig ];

  packagesToBinPath =
  [ cdrtools dvdauthor dvdplusrwtools ];

  buildInputs =
  [ flex bison gettext xineUI
    wxSVG fontconfig xmlto
    docbook5 zip makeWrapper ]
  ++ packagesToBinPath
  ++ optionals dvdisasterSupport [ dvdisaster ]
  ++ optionals udevSupport [ libudev ]
  ++ optionals dbusSupport [ dbus ]
  ++ optionals thumbnailSupport [ libgnomeui ];

  binPath = makeBinPath packagesToBinPath;

  postInstall = ''
    wrapProgram $out/bin/dvdstyler \
      --prefix PATH ":" "${binPath}"
  '';

  meta = with stdenv.lib; {
    description = "A DVD authoring software";
    longDescription = ''
    DVDStyler is a cross-platform free DVD authoring application for the
    creation of professional-looking DVDs. It allows not only burning of video
    files on DVD that can be played practically on any standalone DVD player,
    but also creation of individually designed DVD menus. It is Open Source
    Software and is completely free.

    Some of its features include:
    -  create and burn DVD video with interactive menus
    - design your own DVD menu or select one from the list of ready to use menu
      templates
    - create photo slideshow
    - add multiple subtitle and audio tracks
    - support of AVI, MOV, MP4, MPEG, OGG, WMV and other file formats
    - support of MPEG-2, MPEG-4, DivX, Xvid, MP2, MP3, AC-3 and other audio and
      video formats
    - support of multi-core processor
    - use MPEG and VOB files without reencoding
    - put files with different audio/video format on one DVD (support of
      titleset)
    - user-friendly interface with support of drag & drop
    - flexible menu creation on the basis of scalable vector graphic
    - import of image file for background
    - place buttons, text, images and other graphic objects anywhere on the menu
      screen
    - change the font/color and other parameters of buttons and graphic objects
    - scale any button or graphic object
    - copy any menu object or whole menu
    - customize navigation using DVD scripting
    '';
    homepage = http://www.dvdstyler.org/;
    license = with licenses; gpl2;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; linux;
  };
}
