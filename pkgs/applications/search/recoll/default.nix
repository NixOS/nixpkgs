{ stdenv
, fetchurl
, lib
, mkDerivation
, antiword
, bison
, catdoc
, chmlib
, djvulibre
, file
, gawk
, ghostscript
, gnugrep
, gnused
, gnutar
, groff
, gzip
, libiconv
, libwpd
, libxslt
, lyx
, makeWrapper
, perl
, perlPackages
, pkg-config
, poppler_utils
, python3Packages
, qtbase
, unrtf
, untex
, unzip
, which
, xapian
, zlib
, withGui ? true
, withPython ? with stdenv; buildPlatform.canExecute hostPlatform
}:

let filters = {
      # "binary-name = package" where:
      #  - "${package}/bin/${binary-name}" is the full path to the binary
      #  - occurrences of `"${binary-name}"` in recoll's filters should be fixed up
      awk = gawk;
      antiword = antiword;
      catppt = catdoc;
      djvused = djvulibre;
      djvutxt = djvulibre;
      egrep = gnugrep;
      groff = groff;
      gunzip = gzip;
      iconv = libiconv;
      pdftotext = poppler_utils;
      ps2ascii = ghostscript;
      sed = gnused;
      tar = gnutar;
      unzip = unzip;
      xls2csv = catdoc;
      xsltproc = libxslt;
      unrtf = unrtf;
      untex = untex;
      wpd2html = libwpd;
      perl = perl.passthru.withPackages (p: [ p.ImageExifTool ]);
    };
    filterPath = lib.makeBinPath (map lib.getBin (builtins.attrValues filters));
in

mkDerivation rec {
  pname = "recoll";
  version = "1.33.4";

  src = fetchurl {
    url = "https://www.lesbonscomptes.com/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-ffD49sGYWYEWAFPRtpyDU/CYFvkrEDL21Ddq3QsXCvc=";
  };

  configureFlags = [
    "--enable-recollq"
    "--disable-webkit"
    "--without-systemd"

    # this leaks into the final `librecoll-*.so` binary, so we need
    # to be sure it is taken from `pkgs.file` rather than `stdenv`,
    # especially when cross-compiling
    "--with-file-command=${file}/bin/file"

  ] ++ lib.optionals (!withPython) [
    "--disable-python-module"
    "--disable-python-chm"
  ] ++ lib.optionals (!withGui) [
    "--disable-qtgui"
    "--disable-x11mon"
  ] ++ [
    (lib.withFeature stdenv.isLinux "inotify")
  ];

  env.NIX_CFLAGS_COMPILE = toString [ "-DNIXPKGS" ];

  patches = [
    # fix "No/bad main configuration file" error
    ./fix-datadir.patch
  ];

  nativeBuildInputs = lib.optionals withGui [
    qtbase
  ] ++ [
    pkg-config
  ] ++ lib.optionals withPython [
    python3Packages.setuptools
  ] ++ [
    makeWrapper
    which
  ];

  buildInputs = [
    bison
    chmlib
  ] ++ lib.optionals withPython [
    python3Packages.python
    python3Packages.mutagen
  ] ++ [
    xapian
    zlib
    file
  ] ++ lib.optionals withGui [
    qtbase
  ] ++ lib.optionals stdenv.isDarwin [
    libiconv
  ];

  # the filters search through ${PATH} using a sh proc 'checkcmds' for the
  # filtering utils. Short circuit this by replacing the filtering command with
  # the absolute path to the filtering command.
  postInstall = ''
    substituteInPlace $out/lib/*/site-packages/recoll/rclconfig.py --replace /usr/share/recoll $out/share/recoll
    substituteInPlace $out/share/recoll/filters/rclconfig.py       --replace /usr/share/recoll $out/share/recoll
    for f in $out/share/recoll/filters/* ; do
      if [[ ! "$f" =~ \.zip$ ]]; then
  '' + lib.concatStrings (lib.mapAttrsToList (k: v: (''
        substituteInPlace $f --replace '"${k}"'  '"${lib.getBin v}/bin/${k}"'
  '')) filters) + ''
        substituteInPlace $f --replace '"pstotext"'  '"${lib.getBin ghostscript}/bin/ps2ascii"'
        substituteInPlace $f --replace /usr/bin/perl   ${lib.getBin (perl.passthru.withPackages (p: [ p.ImageExifTool ]))}/bin/perl
      fi
    done
    wrapProgram $out/bin/recoll      --prefix PATH : "${filterPath}"
    wrapProgram $out/bin/recollindex --prefix PATH : "${filterPath}"
    wrapProgram $out/share/recoll/filters/rclaudio.py \
      --prefix PYTHONPATH : $PYTHONPATH
    wrapProgram $out/share/recoll/filters/rclimg \
      --prefix PERL5LIB : "${with perlPackages; makeFullPerlPath [ ImageExifTool ]}"
  '' + lib.optionalString stdenv.isLinux ''
    substituteInPlace  $f --replace '"lyx"' '"${lib.getBin lyx}/bin/lyx"'
  '' + lib.optionalString (stdenv.isDarwin && withGui) ''
    mkdir $out/Applications
    mv $out/bin/recoll.app $out/Applications
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A full-text search tool";
    longDescription = ''
      Recoll is an Xapian frontend that can search through files, archive
      members, email attachments.
    '';
    homepage = "https://www.lesbonscomptes.com/recoll/";
    changelog = "https://www.lesbonscomptes.com/recoll/pages/release-${version}.html";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jcumming ehmry ];

    # `Makefile.am` assumes the ability to run the hostPlatform's python binary at build time
    broken = withPython && (with stdenv; !buildPlatform.canExecute hostPlatform);
  };
}
