{ stdenv, pkgs, fetchgit, autoconf, sbcl, lispPackages, xdpyinfo, texinfo4
, makeWrapper , rlwrap, gnused, gnugrep, coreutils, xprop
, extraModulePaths ? [] }:

stdenv.mkDerivation rec {
  name = "clfswm";

  src = fetchgit {
    url = "https://gitlab.common-lisp.net/clfswm/clfswm.git";
    rev = "refs/heads/master";
    sha256 = "0hynzh3a1zr719cxfb0k4cvh5lskzs616hwn7p942isyvhwzhynd";
  };

  buildInputs = [
    texinfo4 makeWrapper autoconf
    sbcl
    lispPackages.clx
    lispPackages.cl-ppcre
    xdpyinfo
  ];

  patches = [ ./require-clx.patch ];

  # Stripping destroys the generated SBCL image
  dontStrip = true;

  configurePhase = ''
    substituteInPlace load.lisp --replace \
      ";; (setf *contrib-dir* \"/usr/local/lib/clfswm/\")" \
      "(setf *contrib-dir* \"$out/lib/clfswm/\")"
  '';

  installPhase = ''
    mkdir -pv $out/bin
    make DESTDIR=$out install

    # Paths in the compressed image $out/bin/clfswm are not
    # recognized by Nix. Add explicit reference here.
    mkdir $out/nix-support
    echo ${xdpyinfo} ${lispPackages.clx} ${lispPackages.cl-ppcre} > $out/nix-support/depends
  '';

  meta = with stdenv.lib; {
    description = "A(nother) Common Lisp FullScreen Window Manager";
    homepage    = https://common-lisp.net/project/clfswm/;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ robgssp ];
    platforms   = platforms.linux;
    broken      = true;
  };
}
