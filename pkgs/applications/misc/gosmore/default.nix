{ lib, stdenv, fetchsvn, libxml2, gtk2, curl, pkg-config } :

stdenv.mkDerivation rec {
  pname = "gosmore";
  version = "31801";
  # the gosmore svn repository does not lock revision numbers of its externals
  # so we explicitly disable them to avoid breaking the hash
  # especially as the externals appear to be unused
  src = fetchsvn {
    url = "http://svn.openstreetmap.org/applications/rendering/gosmore";
    sha256 = "0qsckpqx7i7f8gkqhkzdamr65250afk1rpnh3nbman35kdv3dsxi";
    rev = version;
    ignoreExternals = true;
  };

  buildInputs = [ libxml2 gtk2 curl ];

  nativeBuildInputs = [ pkg-config ];

  prePatch = ''
    sed -e '/curl.types.h/d' -i *.{c,h,hpp,cpp}
  '';

  patches = [ ./pointer_int_comparison.patch ];
  patchFlags = [ "-p1" "--binary" ]; # patch has dos style eol

  meta = with lib; {
    description = "Open Street Map viewer";
    homepage = "https://sourceforge.net/projects/gosmore/";
    maintainers = with maintainers; [
      raskin
    ];
    platforms = platforms.linux;
    license = licenses.bsd2;
  };
}
