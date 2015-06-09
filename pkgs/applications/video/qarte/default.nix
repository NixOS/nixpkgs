{ stdenv, fetchbzr, python, pyqt4, sip, rtmpdump, makeWrapper }:

stdenv.mkDerivation {
  name = "qarte-2.2.0-147";
  src = fetchbzr {
    url = http://bazaar.launchpad.net/~vincent-vandevyvre/qarte/trunk;
    rev = "147";
    sha256 = "0cl3k3vr3kmp5dls0lbv5pka4zrlyh5816pwl5rkgqmycl11pk51";
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    mv qarte $out/bin/
    substituteInPlace $out/bin/qarte \
      --replace '/usr/bin/python' "${python.interpreter}" \
      --replace '/usr/share' "$out/share"
    wrapProgram $out/bin/qarte \
      --prefix PYTHONPATH : "${pyqt4}/lib/${python.libPrefix}/site-packages:${sip}/lib/${python.libPrefix}/site-packages" \
      --prefix PATH : "${rtmpdump}/bin"

    mkdir -p $out/share/man/man1/
    mv qarte.1 $out/share/man/man1/

    mkdir -p $out/share/qarte
    mv * $out/share/qarte/
  '';

  meta = {
    homepage = https://launchpad.net/qarte;
    description = "A recorder for Arte TV Guide and Arte Concert";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
    platforms = stdenv.lib.platforms.linux;
  };
}
