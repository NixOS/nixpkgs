{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  makeWrapper,
  gtk3,
  json_c,
  taskwarrior2,
}:

stdenv.mkDerivation rec {
  pname = "ptask";
  version = "1.0.0";

  src = fetchurl {
    url = "https://wpitchoune.net/ptask/files/ptask-${version}.tar.gz";
    sha256 = "13nirr7b29bv3w2zc8zxphhmc9ayhs61i11jl4819nabk7vy1kdq";
  };

  buildInputs = [
    gtk3
    json_c
  ];

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  patches = [
    ./tw-version.patch
    ./json_c_is_error.patch
  ];

  preFixup = ''
    wrapProgram "$out/bin/ptask" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \
      --prefix PATH : "${taskwarrior2}/bin"
  '';

  meta = with lib; {
    homepage = "http://wpitchoune.net/ptask/";
    description = "GTK-based GUI for taskwarrior";
    mainProgram = "ptask";
    license = licenses.gpl2;
    maintainers = [ maintainers.spacefrogg ];
    platforms = platforms.linux;
  };
}
