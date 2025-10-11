{
  stdenv,
  fetchFromGitHub,
  pkg-config,
  gsl,
  sqlite,
  lib,
}:

stdenv.mkDerivation rec {
  pname = "apophenia";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "b-k";
    repo = "Apophenia";
    rev = "pkg";
    sha256 = "1rqz3chdjn98biijl3hyyall9pcbpf2hnkfmaq00k6ddd4g23paw";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    gsl.dev
    sqlite.dev
  ];
  propagatedBuildInputs = [
    gsl.dev
    sqlite.dev
  ];

  enableParallelBuilding = true;

  configurePhase = ''./configure --prefix=$out'';
  buildPhase = "make";
  installPhase = ''
    make install

    # Ensure callers get our include dir
    if grep -q '^Cflags:[[:space:]]*$' "$out/lib/pkgconfig/apophenia.pc"; then
      sed -i "s|^Cflags:.*$|Cflags: -I$out/include|" "$out/lib/pkgconfig/apophenia.pc"
    fi

    # Vendor dep .pc files so Requires: resolves without extra env
    ln -sf ${gsl.dev}/lib/pkgconfig/gsl.pc        "$out/lib/pkgconfig/gsl.pc"
    ln -sf ${sqlite.dev}/lib/pkgconfig/sqlite3.pc "$out/lib/pkgconfig/sqlite3.pc"
  '';

  meta = with lib; {
    description = "Apophenia statistical C library (pkg branch)";
    homepage = "http://apophenia.info/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ perihelion ];
    platforms = platforms.linux;
  };
}
