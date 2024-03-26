{ lib
, stdenv
, fetchurl
, gettext
, bzip2
, db
, zlib
}:

stdenv.mkDerivation rec {
  pname = "jigdo";
  version = "0.8.2";

  src = fetchurl {
    url = "https://www.einval.com/~steve/software/jigdo/download/jigdo-${version}.tar.xz";
    hash = "sha256-NvKG2T+mtr94hfSJnJl4lNIdo6YhdlkqwWLZxqhkT54=";
  };

  # unable to parse jigdo-file.sgml
  postPatch = ''
    sed \
      -e "s@.*cd doc.*@@g" \
      -e "s@.*/man1.*@\t\t:@g" \
      -i Makefile.in
  '';

  strictDeps = true;

  nativeBuildInputs = [
    gettext
  ];

  buildInputs = [
    bzip2
    db
    zlib
  ];

  meta = with lib; {
    description = "Download utility that can fetch files from several sources simultaneously";
    homepage = "https://www.einval.com/~steve/software/jigdo/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.unix;
  };
}
