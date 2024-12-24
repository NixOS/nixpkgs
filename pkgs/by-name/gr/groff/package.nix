{
  lib,
  stdenv,
  fetchurl,
  perl,
  enableGhostscript ? false,
  ghostscript,
  gawk,
  libX11,
  libXaw,
  libXt,
  libXmu, # for postscript and html output
  enableHtml ? false,
  psutils,
  netpbm, # for html output
  enableIconv ? false,
  iconv,
  enableLibuchardet ? false,
  libuchardet, # for detecting input file encoding in preconv(1)
  buildPackages,
  autoreconfHook,
  pkg-config,
  texinfo,
  bison,
  bash,
}:

stdenv.mkDerivation rec {
  pname = "groff";
  version = "1.23.0";

  src = fetchurl {
    url = "mirror://gnu/groff/${pname}-${version}.tar.gz";
    hash = "sha256-a5dX9ZK3UYtJAutq9+VFcL3Mujeocf3bLTCuOGNRHBM=";
  };

  outputs = [
    "out"
    "man"
    "doc"
    "info"
    "perl"
  ];

  enableParallelBuilding = true;

  postPatch =
    ''
      # BASH_PROG gets replaced with a path to the build bash which doesn't get automatically patched by patchShebangs
      substituteInPlace contrib/gdiffmk/gdiffmk.sh \
        --replace "@BASH_PROG@" "/bin/sh"
    ''
    + lib.optionalString enableHtml ''
      substituteInPlace src/preproc/html/pre-html.cpp \
        --replace "psselect" "${psutils}/bin/psselect" \
        --replace "pnmcut" "${lib.getBin netpbm}/bin/pnmcut" \
        --replace "pnmcrop" "${lib.getBin netpbm}/bin/pnmcrop" \
        --replace "pnmtopng" "${lib.getBin netpbm}/bin/pnmtopng"
      substituteInPlace tmac/www.tmac.in \
        --replace "pnmcrop" "${lib.getBin netpbm}/bin/pnmcrop" \
        --replace "pngtopnm" "${lib.getBin netpbm}/bin/pngtopnm" \
        --replace "@PNMTOPS_NOSETPAGE@" "${lib.getBin netpbm}/bin/pnmtops -nosetpage"
    ''
    + lib.optionalString (enableGhostscript || enableHtml) ''
      substituteInPlace contrib/pdfmark/pdfroff.sh \
        --replace '$GROFF_GHOSTSCRIPT_INTERPRETER' "${lib.getBin ghostscript}/bin/gs" \
        --replace '$GROFF_AWK_INTERPRETER' "${lib.getBin gawk}/bin/gawk"
    '';

  strictDeps = true;
  nativeBuildInputs =
    [
      autoreconfHook
      pkg-config
      texinfo
    ]
    # Required due to the patch that changes .ypp files.
    ++ lib.optional (stdenv.cc.isClang && lib.versionAtLeast stdenv.cc.version "9") bison;
  buildInputs =
    [
      perl
      bash
    ]
    ++ lib.optionals enableGhostscript [
      ghostscript
      gawk
      libX11
      libXaw
      libXt
      libXmu
    ]
    ++ lib.optionals enableHtml [
      psutils
      netpbm
    ]
    ++ lib.optionals enableIconv [ iconv ]
    ++ lib.optionals enableLibuchardet [ libuchardet ];

  # Builds running without a chroot environment may detect the presence
  # of /usr/X11 in the host system, leading to an impure build of the
  # package. To avoid this issue, X11 support is explicitly disabled.
  configureFlags =
    lib.optionals (!enableGhostscript) [
      "--without-x"
    ]
    ++ [
      "ac_cv_path_PERL=${buildPackages.perl}/bin/perl"
    ]
    ++ lib.optionals enableGhostscript [
      "--with-gs=${lib.getBin ghostscript}/bin/gs"
      "--with-awk=${lib.getBin gawk}/bin/gawk"
      "--with-appresdir=${placeholder "out"}/lib/X11/app-defaults"
    ]
    ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
      "gl_cv_func_signbit=yes"
    ];

  makeFlags = lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    # Trick to get the build system find the proper 'native' groff
    # http://www.mail-archive.com/bug-groff@gnu.org/msg01335.html
    "GROFF_BIN_PATH=${buildPackages.groff}/bin"
    "GROFFBIN=${buildPackages.groff}/bin/groff"
  ];

  doCheck = true;

  postInstall = ''
    for f in 'man.local' 'mdoc.local'; do
        cat '${./site.tmac}' >>"$out/share/groff/site-tmac/$f"
    done

    moveToOutput bin/gropdf $perl
    moveToOutput bin/pdfmom $perl
    moveToOutput bin/roff2text $perl
    moveToOutput bin/roff2pdf $perl
    moveToOutput bin/roff2ps $perl
    moveToOutput bin/roff2dvi $perl
    moveToOutput bin/roff2ps $perl
    moveToOutput bin/roff2html $perl
    moveToOutput bin/glilypond $perl
    moveToOutput bin/mmroff $perl
    moveToOutput bin/roff2x $perl
    moveToOutput bin/afmtodit $perl
    moveToOutput bin/gperl $perl
    moveToOutput bin/chem $perl

    moveToOutput bin/gpinyin $perl
    moveToOutput lib/groff/gpinyin $perl
    substituteInPlace $perl/bin/gpinyin \
      --replace $out/lib/groff/gpinyin $perl/lib/groff/gpinyin

    moveToOutput bin/grog $perl
    moveToOutput lib/groff/grog $perl
    substituteInPlace $perl/bin/grog \
      --replace $out/lib/groff/grog $perl/lib/groff/grog

    find $perl/ -type f -print0 | xargs --null sed -i 's|${buildPackages.perl}|${perl}|'
  '';

  meta = with lib; {
    homepage = "https://www.gnu.org/software/groff/";
    description = "GNU Troff, a typesetting package that reads plain text and produces formatted output";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub ];

    longDescription = ''
      groff is the GNU implementation of troff, a document formatting
      system.  Included in this release are implementations of troff,
      pic, eqn, tbl, grn, refer, -man, -mdoc, -mom, and -ms macros,
      and drivers for PostScript, TeX dvi format, HP LaserJet 4
      printers, Canon CAPSL printers, HTML and XHTML format (beta
      status), and typewriter-like devices.  Also included is a
      modified version of the Berkeley -me macros, the enhanced
      version gxditview of the X11 xditview previewer, and an
      implementation of the -mm macros.
    '';

    outputsToInstall = [
      "out"
      "perl"
    ];
  };
}
