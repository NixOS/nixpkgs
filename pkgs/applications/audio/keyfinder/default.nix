{ stdenv, fetchFromGitHub, libav_0_8, libkeyfinder, qt5, taglib }:

let version = "1.26"; in
stdenv.mkDerivation {
  name = "keyfinder-${version}";

  src = fetchFromGitHub {
    sha256 = "1sfnywc6jdpm03344i6i4pz13mqa4i5agagj4k6252m63cqmjkrc";
    rev = version;
    repo = "is_KeyFinder";
    owner = "ibsh";
  };

  meta = with stdenv.lib; {
    inherit version;
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
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };

  # TODO: upgrade libav when "Audio sample format conversion failed" is fixed
  buildInputs = [ libav_0_8 libkeyfinder qt5.base qt5.xmlpatterns taglib ];

  configurePhase = ''
    substituteInPlace is_KeyFinder.pro \
       --replace "keyfinder.0" "keyfinder" \
       --replace '$$[QT_INSTALL_PREFIX]' "$out"
    qmake
  '';

  enableParallelBuilding = true;
}
