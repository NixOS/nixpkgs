{ mkDerivation, lib, fetchurl, cmake, pkg-config
, qttools, qtx11extras, drumstick
, docbook-xsl-nons
}:

mkDerivation rec {
  pname = "vmpk";
  version = "0.8.6";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-cwfJJVeUokyZI1iGvqBvXjcBR36VGodzrUx5Atv3POM=";
  };

  nativeBuildInputs = [ cmake pkg-config qttools docbook-xsl-nons ];

  buildInputs = [ drumstick qtx11extras ];

  postInstall = ''
    # vmpk drumstickLocales looks here:
    ln -s ${drumstick}/share/drumstick $out/share/
  '';

  meta = with lib; {
    description = "Virtual MIDI Piano Keyboard";
    homepage = "http://vmpk.sourceforge.net/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
