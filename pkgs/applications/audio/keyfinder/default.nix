{ stdenv, fetchFromGitHub, libav_0_8, libkeyfinder, qtbase, qtxmlpatterns, taglib }:

stdenv.mkDerivation rec {
  name = "keyfinder-${version}";
  version = "2.1";

  src = fetchFromGitHub {
    sha256 = "0j9k90ll4cr8j8dywb6zf1bs9vijlx7m4zsh6w9hxwrr7ymz89hn";
    rev = version;
    repo = "is_KeyFinder";
    owner = "ibsh";
  };

  buildInputs = [ libav_0_8 libkeyfinder qtbase qtxmlpatterns taglib ];

  postPatch = ''
    substituteInPlace is_KeyFinder.pro \
       --replace "keyfinder.0" "keyfinder" \
       --replace '$$[QT_INSTALL_PREFIX]' "$out" \
       --replace "-stdlib=libc++" ""
  '';

  configurePhase = ''
    runHook preConfigure
    qmake
    runHook postConfigure
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Musical key detection for digital audio (graphical UI)";
    longDescription = ''
      KeyFinder is an open source key detection tool, for DJs interested in
      harmonic and tonal mixing. Designed primarily for electronic and dance
      music, it is highly configurable and can be applied to many genres. It
      supports a huge range of codecs thanks to LibAV, and writes to metadata
      tags using TagLib. It's intended to be very focused: no library
      management, no track suggestions, no media player. Just a fast,
      efficient workflow tool.
    '';
    homepage = http://www.ibrahimshaath.co.uk/keyfinder/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
