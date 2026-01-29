{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
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
  enableUrwFonts ? false,
  iconv,
  enableLibuchardet ? false,
  libuchardet, # for detecting input file encoding in preconv(1)
  buildPackages,
  autoreconfHook,
  pkg-config,
  texinfo,
  bison,
  bashNonInteractive,
}:
let
  urw-fonts = fetchFromGitHub {
    owner = "ArtifexSoftware";
    repo = "urw-base35-fonts";
    tag = "20200910";
    hash = "sha256-YQl5IDtodcbTV3D6vtJi7CwxVtHHl58fG6qCAoSaP4U=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "groff";
  version = "1.24.0.rc2";

  src = fetchurl {
    # FIXME: Use mirror url once 1.24.0 has been officially released
    #url = "mirror://gnu/groff/groff-${finalAttrs.version}.tar.gz";
    url = "https://alpha.gnu.org/gnu/groff/groff-${finalAttrs.version}.tar.gz";
    hash = "sha256-whK5WHyEYyZyANFcXWY/0o+Pb658Ak/FCAWwbLwOPhU=";
  };

  outputs = [
    "out"
    "man"
    "doc"
    "info"
    "perl"
  ];

  enableParallelBuilding = true;

  postPatch = ''
    # POSIX_SHELL_PROG gets replaced with a path to the build bash which doesn't get automatically patched by patchShebangs
    substituteInPlace contrib/gdiffmk/gdiffmk.sh \
      --replace-fail "@POSIX_SHELL_PROG@" "/bin/sh"
  ''
  + lib.optionalString enableHtml ''
    substituteInPlace src/preproc/html/pre-html.cpp \
      --replace-fail "pamcut" "${lib.getExe' netpbm "pamcut"}" \
      --replace-fail "pnmcrop" "${lib.getExe' netpbm "pnmcrop"}" \
      --replace-fail "pnmtopng" "${lib.getExe' netpbm "pnmtopng"}"
    substituteInPlace tmac/www.tmac.in \
      --replace-fail "pnmcrop" "${lib.getExe' netpbm "pnmcrop"}" \
      --replace-fail "pngtopnm" "${lib.getExe' netpbm "pngtopnm"}" \
      --replace-fail "@PNMTOPS_NOSETPAGE@" "${lib.getExe' netpbm "pnmtops"} -nosetpage"
  '';

  strictDeps = true;
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    texinfo
  ]
  # Required due to the patch that changes .ypp files.
  ++ lib.optional (stdenv.cc.isClang && lib.versionAtLeast stdenv.cc.version "9") bison;
  buildInputs = [
    perl
    bashNonInteractive
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
  configureFlags = [
    "ac_cv_path_PERL=${buildPackages.perl}/bin/perl"
    "--enable-year2038"
  ]
  ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "gl_cv_func_signbit=yes"
  ]
  ++ lib.optionals enableGhostscript [
    "--with-gs=${lib.getExe ghostscript}"
    "--with-awk=${lib.getExe gawk}"
    "--with-appresdir=${placeholder "out"}/lib/X11/app-defaults"
  ]
  ++ lib.optionals (!enableGhostscript) [
    "--without-x"
  ]
  ++ lib.optionals enableUrwFonts [
    "--with-urw-fonts-dir=${urw-fonts}/fonts"
  ]
  ++ lib.optionals (!enableUrwFonts) [
    "--without-urw-fonts"
  ];

  postConfigure = ''
    # Move mom docs instead of linking them to avoid dangling symlinks
    substituteInPlace Makefile \
      --replace-fail '$(LN_S) $(exampledir)' 'mv $(exampledir)'
  '';

  makeFlags = lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    # Trick to get the build system find the proper 'native' groff
    # http://www.mail-archive.com/bug-groff@gnu.org/msg01335.html
    "GROFF_BIN_PATH=${lib.getBin buildPackages.groff}/bin"
    "GROFFBIN=${lib.getExe buildPackages.groff}"
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
    moveToOutput bin/grog $perl
    moveToOutput lib/groff/grog $perl

    find $perl/ -type f -print0 | xargs --null sed -i 's|${buildPackages.perl}|${perl}|'
  '';

  meta = {
    homepage = "https://www.gnu.org/software/groff/";
    description = "GNU Troff, a typesetting package that reads plain text and produces formatted output";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pSub ];

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
})
