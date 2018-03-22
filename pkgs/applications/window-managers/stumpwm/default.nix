{ stdenv, pkgs, fetchgit, autoconf, sbcl, lispPackages, xdpyinfo, texinfo4
, makeWrapper , rlwrap, gnused, gnugrep, coreutils, xprop
, extraModulePaths ? []
, version }:

let
  contrib = (fetchgit {
    url = "https://github.com/stumpwm/stumpwm-contrib.git";
    rev = "9bebe3622b2b6c31a6bada9055ef3862fa79b86f";
    sha256 = "1ml6mjk2fsfv4sf65fdbji3q5x0qiq99g1k8w7a99gsl2i8h60gc";
  });
  versionSpec = {
    "latest" = {
      name = "1.0.0";
      rev = "refs/tags/1.0.0";
      sha256 = "16r0lwhxl8g71masmfbjr7s7m7fah4ii4smi1g8zpbpiqjz48ryb";
      patches = [];
    };
    "0.9.9" = {
      name = "0.9.9";
      rev = "refs/tags/0.9.9";
      sha256 = "0hmvbdk2yr5wrkiwn9dfzf65s4xc2qifj0sn6w2mghzp96cph79k";
      patches = [ ./fix-module-path.patch ];
    };
    "git" = {
        name = "git-20170203";
        rev = "d20f24e58ab62afceae2afb6262ffef3cc318b97";
        sha256 = "1gi29ds1x6dq7lz8lamnhcvcrr3cvvrg5yappfkggyhyvib1ii70";
        patches = [];
    };
  }.${version};
in
stdenv.mkDerivation rec {
  name = "stumpwm-${versionSpec.name}";

  src = fetchgit {
    url = "https://github.com/stumpwm/stumpwm";
    rev = "${versionSpec.rev}";
    sha256 = "${versionSpec.sha256}";
  };

  # NOTE: The patch needs an update for the next release.
  # `(stumpwm:set-module-dir "@MODULE_DIR@")' needs to be in it.
  patches = versionSpec.patches;

  buildInputs = [
    texinfo4 makeWrapper autoconf
    sbcl
    lispPackages.clx
    lispPackages.cl-ppcre
    lispPackages.alexandria
    xdpyinfo
  ];


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
      --prefix PATH ":" "${stdenv.lib.makeBinPath [ rlwrap gnused gnugrep coreutils xprop ]}"

    # Paths in the compressed image $out/bin/stumpwm are not
    # recognized by Nix. Add explicit reference here.
    mkdir $out/nix-support
    echo ${xdpyinfo} > $out/nix-support/xdpyinfo
  '';

  passthru = {
    inherit sbcl lispPackages contrib;
  };

  meta = with stdenv.lib; {
    description = "A tiling window manager for X11";
    homepage    = https://github.com/stumpwm/;
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ the-kenny ];
    platforms   = platforms.linux;
  };
}
