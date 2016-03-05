{ fetchurl, fetchhg, stdenv, xorg, makeWrapper }:

stdenv.mkDerivation rec {
  # Inferno is a rolling release from a mercurial repository. For the verison number
  # of the package I'm using the mercurial commit number.
  rev = "785";
  name = "inferno-${rev}";
  host = "Linux";
  objtype = "386";

  src = fetchhg {
    url    = "https://bitbucket.org/inferno-os/inferno-os";
    sha256 = "1b428ma9fi5skvfrxp91dr43a62kax89wmx7950ahc1cxyx90k7x";
  };

  buildInputs = [ makeWrapper ] ++ (with xorg; [ libX11 libXpm libXext xextproto ]);

  infernoWrapper = ./inferno;

  configurePhase = ''
    sed -e 's@^ROOT=.*$@ROOT='"$out"'/share/inferno@g' \
        -e 's@^OBJTYPE=.*$@OBJTYPE=${objtype}@g' \
        -e 's@^SYSHOST=.*$@SYSHOST=${host}@g' \
        -i mkconfig
    # Get rid of an annoying warning
    sed -e 's/_BSD_SOURCE/_DEFAULT_SOURCE/g' \
        -i ${host}/${objtype}/include/lib9.h
  '';

  buildPhase = ''
    mkdir -p $out/share/inferno
    cp -r . $out/share/inferno
    ./makemk.sh
    export PATH=$PATH:$out/share/inferno/Linux/386/bin
    mk nuke
    mk
  '';

  installPhase = ''
    # Installs executables in $out/share/inferno/${host}/${objtype}/bin
    mk install
    mkdir -p $out/bin
    # Install start-up script
    makeWrapper $infernoWrapper $out/bin/inferno \
      --suffix PATH ':' "$out/share/inferno/Linux/386/bin" \
      --set INFERNO_ROOT "$out/share/inferno"
  '';

  hardeningDisable = [ "fortify" ];

  meta = {
    description = "A compact distributed operating system for building cross-platform distributed systems";
    homepage = "http://inferno-os.org/";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ doublec kovirobi ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
