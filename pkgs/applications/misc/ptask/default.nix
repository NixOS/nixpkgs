{ stdenv, fetchurl, pkgconfig, makeWrapper, gtk3, json_c, taskwarrior }:

stdenv.mkDerivation rec {
  name = "ptask-1.0.0";

  src = fetchurl {
    url = "http://wpitchoune.net/ptask/files/${name}.tar.gz";
    sha256 = "13nirr7b29bv3w2zc8zxphhmc9ayhs61i11jl4819nabk7vy1kdq";
  };

  buildInputs = [ gtk3 json_c ];

  nativeBuildInputs = [ pkgconfig makeWrapper ];

  patches = [ ./tw-version.patch ];

  preFixup = ''
    wrapProgram "$out/bin/ptask" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \
      --prefix PATH : "${taskwarrior}/bin"
  '';

  meta = with stdenv.lib; {
    homepage = http://wpitchoune.net/ptask/;
    description = "GTK-based GUI for taskwarrior";
    license = licenses.gpl2;
    maintainer = [ maintainers.spacefrogg ];
  };
}
