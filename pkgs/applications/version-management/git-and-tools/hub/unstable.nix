{ stdenv, fetchgit, go, ronn, groff, utillinux, Security }:

stdenv.mkDerivation rec {
  name = "hub-${version}";
  version = "2.3.0-pre10";

  src = fetchgit {
    url = https://github.com/github/hub.git;
    rev = "refs/tags/v${version}";
    sha256 = "07sz1i6zxx2g36ayhjp1vjw523ckk5b0cr8b80s1qhar2d2hkibd";
  };

  buildInputs = [ go ronn groff utillinux ]
    ++ stdenv.lib.optional stdenv.isDarwin Security;

  buildPhase = ''
    mkdir bin
    ln -s ${ronn}/bin/ronn bin/ronn

    patchShebangs .
    make all man-pages
  '';

  installPhase = ''
    prefix=$out sh -x < script/install.sh
  '';

  meta = with stdenv.lib; {
    description = "Command-line wrapper for git that makes you better at GitHub";

    license = licenses.mit;
    homepage = https://hub.github.com/;
    maintainers = with maintainers; [ the-kenny ];
    platforms = with platforms; unix;
  };
}
