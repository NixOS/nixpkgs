{ lib, stdenv
, fetchFromGitLab
, perlPackages
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "gcstar";
  version = "1.7.2";

  src = fetchFromGitLab {
    owner = "Kerenoc";
    repo = "GCstar";
    rev = "v${version}";
    sha256 = "1vqfff33sssvlvsva1dflggmwl00j5p64sn1669f9wrbvjkxgpv4";
  };

  nativeBuildInputs = [ wrapGAppsHook ];

  buildInputs = with perlPackages; [
    perl
    ArchiveZip
    DateCalc
    DateTimeFormatStrptime
    Glib
    Gtk2
    GD
    GDGraph
    GDText
    HTMLParser
    JSON
    ImageExifTool
    librelative
    LWPUserAgent
    LWPProtocolHttps
    MP3Info
    MP3Tag
    NetFreeDB
    OggVorbisHeaderPurePerl
    Pango
    XMLSimple
    XMLParser
  ];

  installPhase = ''
    runHook preInstall

    cd gcstar
    perl install --text --prefix=$out

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/gcstar --prefix PERL5LIB : $PERL5LIB
  '';

  meta = with lib; {
    homepage = "https://gitlab.com/Kerenoc/GCstar";
    description = "Manage your collections of movies, games, books, music and more";
    longDescription = ''
      GCstar is an application for managing your collections.
      It supports many types of collections, including movies, books, games, comics, stamps, coins, and many more.
      You can even create your own collection type for whatever unique thing it is that you collect!
      Detailed information on each item can be automatically retrieved from the internet and you can store additional data, such as the location or who you've lent it to.
      You may also search and filter your collections by many criteria.
    '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dasj19 ];
    platforms = platforms.all;
  };
}
