{ stdenv
, fetchurl
, lib
, gtk3
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "gaw";
  version = "20220315";

  src = fetchurl {
    url = "https://download.tuxfamily.org/gaw/download/gaw3-${version}.tar.gz";
    sha256 = "0j2bqi9444s1mfbr7x9rqp232xf7ab9z7ifsnl305jsklp6qmrbg";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gtk3 ];

  meta = with lib; {
    description = "Gtk Analog Wave viewer";
    mainProgram = "gaw";
    longDescription = ''
      Gaw is a software tool for displaying analog waveforms from
      sampled datas, for example from the output of simulators or
      input from sound cards. Data can be imported to gaw using files,
      direct tcp/ip connection or directly from the sound card.
    '';
    homepage = "http://gaw.tuxfamily.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fbeffa ];
    platforms = platforms.linux;
  };
}
