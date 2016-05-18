{ stdenv, pkgs, fetchgit, autoconf, sbcl, lispPackages, xdpyinfo, texinfo4
, makeWrapper , rlwrap, gnused, gnugrep, coreutils, xprop
, extraModulePaths ? [] }:

let
  version = "0.9.9";
  contrib = (fetchgit {
    url = "https://github.com/stumpwm/stumpwm-contrib.git";
    rev = "9bebe3622b2b6c31a6bada9055ef3862fa79b86f";
    sha256 = "1ml6mjk2fsfv4sf65fdbji3q5x0qiq99g1k8w7a99gsl2i8h60gc";
  });
in
stdenv.mkDerivation rec {
  name = "stumpwm-${version}";

  src = fetchgit {
    url = "https://github.com/stumpwm/stumpwm";
    rev = "refs/tags/${version}";
    sha256 = "05fkng2wlmhy3kb9zhrrv9zpa16g2p91p5y0wvmwkppy04cw04ps";
  };

  buildInputs = [
    texinfo4 makeWrapper autoconf
    sbcl
    lispPackages.clx
    lispPackages.cl-ppcre
    xdpyinfo
  ];

  # NOTE: The patch needs an update for the next release.
  # `(stumpwm:set-module-dir "@MODULE_DIR@")' needs to be in it.
  patches = [ ./fix-module-path.patch ];

  # Stripping destroys the generated SBCL image
  dontStrip = true;

  configurePhase = ''
    ./autogen.sh
    ./configure --prefix=$out --with-module-dir=$out/share/stumpwm/modules
  '';

  preBuild = ''
    cp -r --no-preserve=mode ${contrib} modules
    substituteInPlace  head.lisp \
      --replace 'run-shell-command "xdpyinfo' 'run-shell-command "${xdpyinfo}/bin/xdpyinfo'
  '';

  installPhase = ''
    mkdir -pv $out/bin
    make install

    mkdir -p $out/share/stumpwm/modules
    cp -r modules/* $out/share/stumpwm/modules/
    for d in ${stdenv.lib.concatStringsSep " " extraModulePaths}; do
      cp -r --no-preserve=mode "$d" $out/share/stumpwm/modules/
    done

    # Copy stumpish;
    cp $out/share/stumpwm/modules/util/stumpish/stumpish $out/bin/
    chmod +x $out/bin/stumpish
    wrapProgram $out/bin/stumpish \
      --prefix PATH ":" "${rlwrap}/bin:${gnused}/bin:${gnugrep}/bin:${coreutils}/bin:${xprop}/bin"

    # Paths in the compressed image $out/bin/stumpwm are not
    # recognized by Nix. Add explicit reference here.
    mkdir $out/nix-support
    echo ${xdpyinfo} > $out/nix-support/xdpyinfo
  '';

  passthru = {
    inherit sbcl lispPackages;
  };

  meta = with stdenv.lib; {
    description = "A tiling window manager for X11";
    homepage    = https://github.com/stumpwm/;
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ hiberno the-kenny ];
    platforms   = platforms.linux;
  };
}
