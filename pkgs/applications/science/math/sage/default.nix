# TODO
# - consider writing a script to convert spkgs to nix packages, similar to vim
#   or cabal2nix. This would allow a more efficient and "cleaner" build, greater
#   flexibility and the possibility to select which dependencies to add and which
#   to remove. It would also allow to use system packages for some dependencies
#   and recompile others (optimized for the system) without recompiling everything.
# - add optdeps:
#   - imagemagick
#   - texlive full for documentation
#   - ...
# - further seperate build outputs. Also maybe run `make doc`.
#   Configure flags like --bindir and --libdir oculd also be used for that, see
#   ./configure --help`.

# Other resources:
# - https://wiki.debian.org/DebianScience/Sage
# - https://github.com/cschwan/sage-on-gentoo
# - https://git.archlinux.org/svntogit/community.git/tree/trunk?h=packages/sagemath

{ stdenv
, bash
, fetchurl
, perl
, gfortran6
, python
, autoreconfHook
, gettext
, which
, texlive
, texinfo
, hevea
, buildDocs ? false
, optimize ? false # optimize sage to the current system (obviously impure)
}:

stdenv.mkDerivation rec {
  version = "8.1";
  name = "sage-${version}";

  # Modified version of patchShebangs that patches to the sage-internal version if possible
  # and falls back to the system version if not.
  patchSageShebangs = ./patchSageShebangs.sh;
  src = fetchurl {
    # Note that the source is *not* fetched from github, since that doesn't
    # the upstream folder with all the source tarballs of the spkgs.
    # If those are not present they are fetched at build time, which breaks
    # when building in a sandbox (and probably only works if you install the
    # latest sage version).
    urls = [
      "http://mirrors.mit.edu/sage/src/sage-${version}.tar.gz"
      "ftp://ftp.fu-berlin.de/unix/misc/sage/src/sage-${version}.tar.gz"
      "http://sagemath.polytechnic.edu.na/src/sage-${version}.tar.gz"
      "ftp://ftp.sun.ac.za/pub/mirrors/www.sagemath.org/src/sage-${version}.tar.gz"
      "http://sagemath.mirror.ac.za/src/sage-${version}.tar.gz"
      "http://ftp.leg.uct.ac.za/pub/packages/sage/src/sage-${version}.tar.gz"
      "http://mirror.ufs.ac.za/sagemath/src/sage-${version}.tar.gz"
      "http://mirrors-usa.go-parts.com/sage/sagemath/src/sage-${version}.tar.gz"
      "http://www.cecm.sfu.ca/sage/src/sage-${version}.tar.gz"
      "http://files.sagemath.org/src/sage-${version}.tar.gz"
      "http://mirrors.xmission.com/sage/src/sage-${version}.tar.gz"
      "http://sagemath.c3sl.ufpr.br/src/sage-${version}.tar.gz"
      "http://linorg.usp.br/sage/src/sage-${version}.tar.gz"
      "http://mirror.hust.edu.cn/sagemath/src/sage-${version}.tar.gz"
      "http://ftp.iitm.ac.in/sage/src/sage-${version}.tar.gz"
      "http://ftp.kaist.ac.kr/sage/src/sage-${version}.tar.gz"
      "http://ftp.riken.jp/sagemath/src/sage-${version}.tar.gz"
      "http://mirrors.tuna.tsinghua.edu.cn/sagemath/src/sage-${version}.tar.gz"
      "http://mirrors.ustc.edu.cn/sagemath/src/sage-${version}.tar.gz"
      "http://ftp.tsukuba.wide.ad.jp/software/sage/src/sage-${version}.tar.gz"
      "http://ftp.yz.yamagata-u.ac.jp/pub/math/sage/src/sage-${version}.tar.gz"
      "http://mirror.yandex.ru/mirrors/sage.math.washington.edu/src/sage-${version}.tar.gz"
      "http://mirror.aarnet.edu.au/pub/sage/src/sage-${version}.tar.gz"
      "http://sage.mirror.garr.it/mirrors/sage/src/sage-${version}.tar.gz"
      "http://www.mirrorservice.org/sites/www.sagemath.org/src/sage-${version}.tar.gz"
      "http://mirror.switch.ch/mirror/sagemath/src/sage-${version}.tar.gz"
      "https://mirrors.up.pt/pub/sage/src/sage-${version}.tar.gz"
      "http://www-ftp.lip6.fr/pub/math/sagemath/src/sage-${version}.tar.gz"
      "http://ftp.ntua.gr/pub/sagemath/src/sage-${version}.tar.gz"
    ];
    sha256 = "1cpcs1mr0yii64s152xmxyd450bfzjb22jjj0zh9y3n6g9alzpyq";
  };

  postPatch = ''
    substituteAllInPlace src/bin/sage-env
    bash=${bash} substituteAllInPlace build/bin/sage-spkg
  '';

  installPhase = ''
    # Sage installs during first `make`, `make install` is no-op and just takes time.
  '';

  outputs = [ "out" ] ++ stdenv.lib.optionals (buildDocs) [ "doc" ];

  buildInputs = [
    bash # needed for the build
    perl # needed for the build
    python # needed for the build
    gfortran6 # needed to build giac, openblas
    autoreconfHook # needed to configure sage with prefix
    gettext # needed to build the singular spkg
    which # needed in configure of mpir
    texinfo # needed to build maxima
  ] ++ stdenv.lib.optionals(buildDocs) [
    hevea # needed to build the docs of the giac spkg
    (texlive.combine { inherit (texlive)
      scheme-basic
      collection-pstricks # needed by giac
      times # font needed by giac
      stmaryrd # needed by giac
      babel-greek # optional for giac, otherwise throws a bunch of latex command not founds
      ;
    })
  ];

  nativeBuildInputs = [ gfortran6 perl which ];

  patches = [
    # fix usages of /bin/rm
    ./spkg-singular.patch
    # help python find the crypt library
    # patches python3 and indirectly python2, since those installation files are symlinked
    ./spkg-python.patch
    # fix usages of /usr/bin/perl
    ./spkg-git.patch
    # fix usages of /bin/cp and add necessary argument to function call
    ./spkg-giac.patch
    # environment
    ./env.patch
    # adjust wrapper shebang and patch shebangs after each spkg build
    ./shebangs.patch
  ];

  enableParallelBuilding = true;

  hardeningDisable = [
    "format" # needed to build palp, for lines like `printf(ctime(&_NFL->TIME))`
    # TODO could be patched with `sed s|printf(ctime(\(.*\)))|%s... or fixed upstream
  ];

  configureFlags = stdenv.lib.optionals(buildDocs) [ "--docdir=$(doc)" ];
  preConfigure = ''
    export SAGE_NUM_THREADS="$NIX_BUILD_CORES"

    export HOME=/tmp/sage-home
    export SAGE_ROOT="$PWD"
    export SAGE_SRC="$PWD"

    mkdir -p "$HOME"
    mkdir -p "$out"

    # we need to keep the source around
    dir="$PWD"
    cd ..
    mv "$dir" "$out/sage-root"

    export SAGE_SPKG_INSTALL_DOCS='no'
    cd "$out/sage-root" # build in target dir, since `make` is also `make install`
  ''
  + stdenv.lib.optionalString (buildDocs) ''
    mkdir -p "$doc"
    export SAGE_DOC="$doc"
    export SAGE_DOCBUILD_OPTS="--no-pdf-links -k"
  ''
  + stdenv.lib.optionalString (!optimize) ''
    export SAGE_FAT_BINARY=yes
  '';

  buildFlags = if (buildDocs) then "doc" else "build";

  # for reference: http://doc.sagemath.org/html/en/installation/source.html
  preBuild = ''
    # symlink python to make sure the shebangs are patched to the sage path
    # while still being able to use python before building it
    # (this is important because otherwise sage will try to install python
    # packages globally later on)
    ln -s "${python}/bin/python2" $out/bin/python2
    ln -s "$out/bin/python2" $out/bin/python
    touch $out/bin/python3
    bash $patchSageShebangs .
  '';

  postBuild = ''
    # Clean up
    rm -r "$out/sage-root/upstream" # don't keep the sources of all the spkgs
    rm -rf "$out/sage-root/src/build"
    rm -rf "$out/sage-root/src/autom4te.cache"
    rm -rf "$out/sage-root/src/config"
    rm -rf "$out/sage-root/src/m4"
    rm -rf "$out/sage-root/.git"
    rm -r "$out/sage-root/logs"
    rm -r "$out"/lib/python*/test
    # Fix dependency cycle between out and doc
    rm -f "$out/sage-root/config.log"
    rm -f "$out/sage-root/config.status"
    rm -f "$out/sage-root/build/make/Makefile-auto"
    rm -f "$out/sage-home/.sage/gap/libgap-workspace-"*
    # Make sure unnessessary packages don't end up in the build closure
    find "$out" \
        -iname 'config.log' \
        -delete \
        -or -iname 'Makefile' \
        -delete
    rm -f "$out/lib/R/etc/Renviron"
    # Make sure all shebangs are properly patched
    bash $patchSageShebangs $out
  '';

  # TODO there are some doctest failures, which seem harmless.
  # We should figure out a way to fix the failures or ignore only those tests.
  doCheck = false;

  checkTarget = "ptestalllong"; # all long tests in parallell
  preCheck = ''
    export SAGE_TIMEOUT=0 # no timeout
    export SAGE_TIMEOUT_LONG=0 # no timeout
  '';

  meta = {
    homepage = http://www.sagemath.org;
    description = "A free open source mathematics software system";
    # taken from the homepage
    longDescription = ''
      SageMath is a free open-source mathematics software system licensed under the GPL. It builds on top of many existing open-source packages: NumPy, SciPy, matplotlib, Sympy, Maxima, GAP, FLINT, R and many more. Access their combined power through a common, Python-based language or directly via interfaces or wrappers.
      Mission: Creating a viable free open source alternative to Magma, Maple, Mathematica and Matlab.
    '';
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ timokau ];
  };
}
