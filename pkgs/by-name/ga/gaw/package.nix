{
  stdenv,
  fetchurl,
  lib,
  gtk3,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gaw";
  version = "20220315";

  src = fetchurl {
    url = "https://download.tuxfamily.org/gaw/download/gaw3-${finalAttrs.version}.tar.gz";
    sha256 = "0j2bqi9444s1mfbr7x9rqp232xf7ab9z7ifsnl305jsklp6qmrbg";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gtk3 ];

  # gawmenus.c:1227:14: error: assignment to 'GMenuModel *' {aka 'struct _GMenuModel *'} from incompatible pointer type 'GObject *' {aka 'struct _GObject *'} []
  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  meta = {
    description = "Gtk Analog Wave viewer";
    mainProgram = "gaw";
    longDescription = ''
      Gaw is a software tool for displaying analog waveforms from
      sampled datas, for example from the output of simulators or
      input from sound cards. Data can be imported to gaw using files,
      direct tcp/ip connection or directly from the sound card.
    '';
    homepage = "http://gaw.tuxfamily.org";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ fbeffa ];
    platforms = lib.platforms.linux;
  };
})
