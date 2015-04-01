{ stdenv, fetchFromGitHub, libav_0_8, libkeyfinder, qt5, taglib }:

stdenv.mkDerivation rec {
  version = "1.25-17-gf670607";
  name = "keyfinder-${version}";

  src = fetchFromGitHub {
    repo = "is_KeyFinder";
    owner = "ibsh";
    rev = "f6706074435ac14c5238ee3f0dd22ac22d72af9c";
    sha256 = "1sfnywc6jdpm03344i6i4pz13mqa4i5agagj4k6252m63cqmjkrc";
  };

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
    license = with licenses; gpl3Plus;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };

  # TODO: upgrade libav when "Audio sample format conversion failed" is fixed
  buildInputs = [ libav_0_8 libkeyfinder qt5 taglib ];

  configurePhase = ''
    substituteInPlace is_KeyFinder.pro \
       --replace "keyfinder.0" "keyfinder" \
       --replace '$$[QT_INSTALL_PREFIX]' "$out"
    qmake
  '';

  enableParallelBuilding = true;
}
