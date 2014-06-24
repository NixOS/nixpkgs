{ fetchurl, fetchhg, stdenv, xlibs, gcc46, makeWrapper }:

stdenv.mkDerivation rec {
  # Inferno is a rolling release from a mercurial repository. For the verison number
  # of the package I'm using the mercurial commit number.
  version = "645";
  name = "inferno-${version}";

  # The mercurial repository does not contain all the components needed for the
  # runtime system. The 'base' package contains these. For this package I download
  # the base, extract the elements required from that, and add them to the source
  # pulled from the mercurial repository.
  srcBase = fetchurl {
    url = "http://www.vitanuova.com/dist/4e/inferno-20100120.tgz";
    sha256 = "0msvy3iwl4n5k0ry0xiyysjkq0qsawmwn3hvg67hbi5y8g7f7l88";
  };

  src = fetchhg {
    url    = "https://inferno-os.googlecode.com/hg";
    rev    = "7ab390b860ca";
    sha256 = "09y0iclb3yy10gw1p0182sddg64xh60q2fx4ai7lxyfb65i76qbh";
  };

  # Fails with gcc48 due to inferno triggering an optimisation issue with floating point.
  buildInputs = [ gcc46 xlibs.libX11 xlibs.libXpm xlibs.libXext xlibs.xextproto makeWrapper ];

  infernoWrapper = ./inferno;

  configurePhase = ''
    tar --strip-components=1 -xvf $srcBase inferno/fonts inferno/Mkdirs inferno/empties
    sed -e 's@^ROOT=.*$@ROOT='"$out"'/share/inferno@g' -e 's@^OBJTYPE=.*$@OBJTYPE=386@g' -e 's@^SYSHOST=.*$@SYSHOST=Linux@g' -i mkconfig
    mkdir prof
    sh Mkdirs
  '';

  buildPhase = ''
    export PATH=$PATH:$out/share/inferno/Linux/386/bin
    mkdir -p $out/share/inferno
    cp -r . $out/share/inferno
    ./makemk.sh
    mk nuke
    mk
  '';

  installPhase = ''
    mk install
    mkdir -p $out/bin
    makeWrapper $out/share/inferno/Linux/386/bin/emu $out/bin/emu \
      --suffix LD_LIBRARY_PATH ':' "${gcc46.gcc}/lib" \
      --suffix PATH ':' "$out/share/inferno/Linux/386/bin"
    makeWrapper $infernoWrapper $out/bin/inferno \
      --suffix LD_LIBRARY_PATH ':' "${gcc46.gcc}/lib" \
      --suffix PATH ':' "$out/share/inferno/Linux/386/bin" \
      --set INFERNO_ROOT "$out/share/inferno"
  '';

  meta = {
    description = "A compact distributed operating system for building cross-platform distributed systems";
    homepage = "http://inferno-os.org/";
    license = stdenv.lib.licenses.gpl2;
    maintainer = [ "Chris Double <chris.double@double.co.nz>" ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
