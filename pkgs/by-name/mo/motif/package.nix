{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  buildPackages,
  pkg-config,
  libtool,
  xbitmaps,
  libXext,
  libXft,
  libXrender,
  libXmu,
  libXt,
  expat,
  libjpeg,
  libpng,
  libiconv,
  flex,
  libXp,
  libXau,
  demoSupport ? false,
}:
# refer to the gentoo package

stdenv.mkDerivation rec {
  pname = "motif";
  version = "2.3.8";

  src = fetchurl {
    url = "mirror://sourceforge/motif/${pname}-${version}.tar.gz";
    sha256 = "1rxwkrhmj8sfg7dwmkhq885valwqbh26d79033q7vb7fcqv756w5";
  };

  buildInputs = [
    flex
    libtool
    xbitmaps
    libXext
    libXft
    libXrender
    libXmu
    libXt
    expat
    libjpeg
    libpng
    libiconv
  ];

  nativeBuildInputs = [
    pkg-config
    flex
  ];

  propagatedBuildInputs = [
    libXp
    libXau
  ];

  strictDeps = true;

  postPatch = ''
    # File existence fails when cross-compiling - useless for Nix anyhow
    substituteInPlace ./configure --replace-fail \
      'as_fn_error $? "cannot check for file existence' '#' \
      --replace-fail 'pkg-config' '${stdenv.cc.targetPrefix}pkg-config'
  ''
  + lib.optionalString (!demoSupport) ''
    sed 's/\<demos\>//' -i Makefile.{am,in}
  ''
  # for cross builds, we must copy several build tools from a native build
  # (and we must ensure they are not removed and recreated by make)
  + lib.optionalString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    cp "${buildPackages.motif}/lib/internals/makestrs" config/util/makestrs
    substituteInPlace config/util/Makefile.in \
      --replace-fail '@rm -f makestrs$(EXEEXT)' "" \
      --replace-fail '$(AM_V_CCLD)$(LINK) $(makestrs_OBJECTS) $(makestrs_LDADD) $(LIBS)' ""

    cp "${buildPackages.motif}"/lib/internals/{wml,wmluiltok,wmldbcreate} tools/wml/
    substituteInPlace tools/wml/Makefile.in \
      --replace-fail '@rm -f wmldbcreate$(EXEEXT)' "" \
      --replace-fail '$(AM_V_CCLD)$(LINK) $(wmldbcreate_OBJECTS) $(wmldbcreate_LDADD) $(LIBS)' "" \
      --replace-fail '@rm -f wmluiltok$(EXEEXT)' "" \
      --replace-fail '$(AM_V_CCLD)$(LINK) $(wmluiltok_OBJECTS) $(wmluiltok_LDADD) $(LIBS)' "" \
      --replace-fail '@rm -f wml$(EXEEXT)' "" \
      --replace-fail '$(AM_V_CCLD)$(LINK) $(wml_OBJECTS) $(wml_LDADD) $(LIBS)' ""
  '';

  patches = [
    ./Remove-unsupported-weak-refs-on-darwin.patch
    ./Add-X.Org-to-bindings-file.patch
    (fetchpatch rec {
      name = "fix-format-security.patch";
      url = "https://raw.githubusercontent.com/void-linux/void-packages/b9a1110dabb01c052dadc1abae1413bd4afe3652/srcpkgs/motif/patches/02-${name}";
      sha256 = "13vzpf8yxvhf4gl7q0yzlr6ak1yzx382fsqsrv5lc8jbbg4nwrrq";
    })
    (fetchpatch {
      name = "missing-headers.patch";
      url = "https://gitlab.freedesktop.org/xorg/lib/libxpm/-/commit/4cedf181bcfe13e5d206554c51edb82cb17e7ad5.patch";
      extraPrefix = "lib/Xm/";
      stripLen = 2;
      hash = "sha256-WlagHOgf2gZDxXN+SSEW6de1FuN4fbpd9zviMwo1+HI=";
    })
    (fetchurl {
      name = "noreturn.patch";
      url = "https://dev.gentoo.org/~ulm/distfiles/motif-2.3.8-patches-5.tar.xz";
      downloadToTemp = true;
      postFetch = ''
        tar -xOf $downloadedFile patch/12_all_noreturn.patch > $out
      '';
      hash = "sha256-FyaBfqD/TuJVFFHZlp1/b1MyL8BJAfV43ktuusgxbfE=";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/macports/macports-ports/acc8c7cb2247d9892bf5a52eb92431a4c0c8e1cd/x11/openmotif/files/wcs-functions.patch";
      extraPrefix = "";
      hash = "sha256-w3zCUs/RbnRoUJ0sNCI00noEOkov/IGV/zIygakSQqc=";
    })
  ];

  # provide correct configure answers for cross builds
  configureFlags = [
    "ac_cv_func_setpgrp_void=${if stdenv.hostPlatform.isBSD then "no" else "yes"}"
  ];

  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = toString [
      "-Wno-error=implicit-function-declaration"
      "-Wno-error=incompatible-function-pointer-types"
    ];
  };

  enableParallelBuilding = true;

  # copy tools for cross builds
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    mkdir -p "$out/lib/internals"
    cp config/util/makestrs tools/wml/{wml,wmluiltok,.libs/wmldbcreate} "$out/lib/internals"
  '';

  meta = with lib; {
    homepage = "https://motif.ics.com";
    description = "Unix standard widget-toolkit and window-manager";
    platforms = platforms.unix;
    license = with licenses; [ lgpl21Plus ];
    maintainers = with maintainers; [ qyliss ];
    broken = demoSupport && stdenv.cc.isClang && lib.versionAtLeast stdenv.cc.version "16";
  };
}
