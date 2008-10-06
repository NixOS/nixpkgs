{ bdbSupport ? false # build support for Berkeley DB repositories
, httpServer ? false # build Apache DAV module
, httpSupport ? false # client must support http
, sslSupport ? false # client must support https
, compressionSupport ? false # client must support http compression
, pythonBindings ? false
, perlBindings ? false
, javahlBindings ? false
, stdenv, fetchurl, apr, aprutil, neon, zlib
, httpd ? null, expat, swig ? null, jdk ? null
}:

assert bdbSupport -> aprutil.bdbSupport;
assert httpServer -> httpd != null && httpd.expat == expat;
assert pythonBindings -> swig != null && swig.pythonSupport;
assert javahlBindings -> jdk != null;
assert sslSupport -> neon.sslSupport;
assert compressionSupport -> neon.compressionSupport;

stdenv.mkDerivation rec {

  version = "1.5.2";

  name = "subversion-${version}";

  src = fetchurl {
    url = http://subversion.tigris.org/downloads/subversion-1.5.2.tar.bz2;
    sha256 = "1xf7hacidr8wxdf2m64lhv42sjis5hz469yslcpp4xfd6n846k3w";
  };

  buildInputs = [zlib apr aprutil]
    ++ stdenv.lib.optional httpSupport neon;

  inherit perlBindings; # set a flag (see git expression)

  configureFlags = ''
    --disable-static
    --disable-keychain
    ${if bdbSupport then "--with-berkeley-db" else "--without-berkeley-db"}
    ${if httpServer then
        "--with-apxs=${httpd}/bin/apxs --with-apr=${httpd} --with-apr-util=${httpd}"
      else
        "--without-apxs"}
    ${if pythonBindings || perlBindings then "--with-swig=${swig}" else "--without-swig"}
    ${if javahlBindings then "--enable-javahl --with-jdk=${jdk}" else ""}
    --disable-neon-version-check
  '';

  postInstall = ''
    ensureDir $out/share/emacs/site-lisp
    cp contrib/client-side/emacs/*.el $out/share/emacs/site-lisp/
  ''; # */

  passthru = {
    inherit perlBindings pythonBindings;
    python = if swig != null && swig ? python then swig.python else null;
  };

  meta = {
    description = "A version control system intended to be a compelling replacement for CVS in the open source community";
    homepage = http://subversion.tigris.org/;
  };
}

