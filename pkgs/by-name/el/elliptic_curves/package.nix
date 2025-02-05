{
  lib,
  stdenv,
  fetchurl,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "elliptic_curves";
  version = "0.8.1";

  src = fetchurl {
    url = "mirror://sageupstream/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "0l7xh4abw5sb4d37r0ylr3vwb88fpx2zrvfm5ql0c7yrv5q59fjz";
  };

  # Script that creates the sqlite database from the allcurves textfile
  spkg-install = fetchurl {
    url = "https://raw.githubusercontent.com/sagemath/sage/07d6c37d18811e2b377a9689790a7c5e24da16ba/build/pkgs/${pname}/spkg-install.py";
    sha256 = "116g684i6mvs11fvb6fzfsr4fn903axn31vigdyb8bgpf8l4hvc5";
  };

  installPhase = ''
    # directory layout as spkg-install.py expects
    dir="$PWD"
    cd ..
    ln -s "$dir" "src"

    # environment spkg-install.py expects
    mkdir -p "$out/share"
    export SAGE_SHARE="$out/share"
    export PYTHONPATH=$PWD

    ${python3.interpreter} ${spkg-install}
  '';

  meta = with lib; {
    description = "Databases of elliptic curves";
    longDescription = ''
      Includes two databases:

       * A small subset of the data in John Cremona's database of elliptic curves up
         to conductor 10000. See http://www.warwick.ac.uk/~masgaj/ftp/data/ or
         http://sage.math.washington.edu/cremona/INDEX.html
       * William Stein's database of interesting curves
    '';
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = teams.sage.members;
  };
}
