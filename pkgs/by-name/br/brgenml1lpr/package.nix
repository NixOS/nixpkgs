{
  lib,
  fetchurl,
  pkgsi686Linux,
}:

/*
    [Setup instructions](http://support.brother.com/g/s/id/linux/en/instruction_prn1a.html).

    URI example
     ~  `lpd://BRW0080927AFBCE/binary_p1`

    Logging
    -------

    `/tmp/br_lpdfilter_ml1.log` when `$ENV{LPD_DEBUG} > 0` in `filter_BrGenML1`
    which is activated automatically when `DEBUG > 0` in `brother_lpdwrapper_BrGenML1`
    from the cups wrapper.

    Issues
    ------

     -  filter_BrGenML1 ln 196 `my $GHOST_SCRIPT=`which gs`;`

        `GHOST_SCRIPT` is empty resulting in an empty `/tmp/br_lpdfilter_ml1_gsout.dat` file.
        See `/tmp/br_lpdfilter_ml1.log` for the executed command.

    Notes
    -----

     -  The `setupPrintcap` has totally no use in our context.
*/

pkgsi686Linux.stdenv.mkDerivation (finalAttrs: {
  pname = "brgenml1lpr";
  version = "3.1.0-1";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf101123/brgenml1lpr-${finalAttrs.version}.i386.deb";
    hash = "sha256-LgG/rcgrBBbwXBi6HT0jmZZyu420iDKBWjr9LLOVu30=";
  };

  unpackPhase = ''
    ar x $src
    tar xfvz data.tar.gz
  '';

  nativeBuildInputs = [
    pkgsi686Linux.makeWrapper
    pkgsi686Linux.autoPatchelfHook
  ];

  buildInputs = [
    pkgsi686Linux.cups
    pkgsi686Linux.perl
    pkgsi686Linux.stdenv.cc.libc
    pkgsi686Linux.ghostscript
    pkgsi686Linux.which
  ];

  dontBuild = true;

  patchPhase = ''
    INFDIR=opt/brother/Printers/BrGenML1/inf
    LPDDIR=opt/brother/Printers/BrGenML1/lpd

    # Setup max debug log by default.
    substituteInPlace $LPDDIR/filter_BrGenML1 \
      --replace "BR_PRT_PATH =~" "BR_PRT_PATH = \"$out/opt/brother/Printers/BrGenML1\"; #" \
      --replace "PRINTER =~" "PRINTER = \"BrGenML1\"; #"
  '';

  installPhase = ''
    INFDIR=opt/brother/Printers/BrGenML1/inf
    LPDDIR=opt/brother/Printers/BrGenML1/lpd

    mkdir -p $out/$INFDIR
    cp -rp $INFDIR/* $out/$INFDIR
    mkdir -p $out/$LPDDIR
    cp -rp $LPDDIR/* $out/$LPDDIR

    wrapProgram $out/$LPDDIR/filter_BrGenML1 \
      --prefix PATH ":" "${pkgsi686Linux.ghostscript}/bin" \
      --prefix PATH ":" "${pkgsi686Linux.which}/bin"
  '';

  meta = {
    description = "Brother BrGenML1 LPR driver";
    homepage = "http://www.brother.com";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = lib.platforms.linux;
    license = lib.licenses.unfreeRedistributable;
    maintainers = with lib.maintainers; [ jraygauthier ];
  };
})
