{ stdenv
, fetchurl
, lib
, mkDerivation
, antiword
, aspell
, bison
, catdoc
, catdvi
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
, meson
, ninja
, perl
, perlPackages
, pkg-config
, poppler_utils
, python3Packages
, qtbase
, qttools
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
      catdvi = catdvi;
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
    useInotify = if stdenv.hostPlatform.isLinux then "true" else "false";
in

mkDerivation rec {
  pname = "recoll";
  version = "1.39.1";

  src = fetchurl {
    url = "https://www.recoll.org/${pname}-${version}.tar.gz";
    hash = "sha256-Eeadj/AnuztCb7VIYEy4hKbduH3CzK53tADvI9+PWmQ=";
  };

  mesonFlags = [
    "-Drecollq=true"
    "-Dwebkit=false"
    "-Dsystemd=false"

    # this leaks into the final `librecoll-*.so` binary, so we need
    # to be sure it is taken from `pkgs.file` rather than `stdenv`,
    # especially when cross-compiling
    "-Dfile-command=${file}/bin/file"

  ] ++ lib.optionals (!withPython) [
    "-Dpython-module=false"
    "-Dpython-chm=false"
  ] ++ lib.optionals (!withGui) [
    "-Dqtgui=false"
    "-Dx11mon=false"
  ] ++ [
    "-Dinotify=${useInotify}"
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-DNIXPKGS"
    "-fpermissive" # libxml2-2.12 changed const qualifiers
  ];

  patches = [
    # fix "No/bad main configuration file" error
    ./fix-datadir.patch
    # use the same configure based build for darwin as linux
    ./0001-no-qtgui-darwin-bundle.patch
  ];

  nativeBuildInputs = [
    makeWrapper
    meson
    ninja
    pkg-config
    which
  ] ++ lib.optionals withGui [
    qtbase
    qttools
  ] ++ lib.optionals withPython [
    python3Packages.setuptools
  ];

  buildInputs = [
    aspell
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
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  qtWrapperArgs = [
    "--prefix PATH : ${filterPath}"
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
    wrapProgram $out/share/recoll/filters/rclaudio.py \
      --prefix PYTHONPATH : $PYTHONPATH
    wrapProgram $out/share/recoll/filters/rcljoplin.py \
      --prefix PYTHONPATH : $out/${python3Packages.python.sitePackages}
    wrapProgram $out/share/recoll/filters/rclimg \
      --prefix PERL5LIB : "${with perlPackages; makeFullPerlPath [ ImageExifTool ]}"
  '' + lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace  $f --replace '"lyx"' '"${lib.getBin lyx}/bin/lyx"'
  '' + lib.optionalString (stdenv.hostPlatform.isDarwin && withGui) ''
    mkdir $out/Applications
    mv $out/bin/recoll.app $out/Applications
  '';

  # create symlink after fixup to prevent double wrapping of recoll
  postFixup = lib.optionalString (stdenv.hostPlatform.isDarwin && withGui) ''
    ln -s ../Applications/recoll.app/Contents/MacOS/recoll $out/bin/recoll
  '';

  enableParallelBuilding = false; # XXX: -j44 tried linking befoire librecoll had been created

  meta = with lib; {
    description = "Full-text search tool";
    longDescription = ''
      Recoll is an Xapian frontend that can search through files, archive
      members, email attachments.
    '';
    homepage = "https://www.recoll.org";
    changelog = "https://www.recoll.org/pages/release-history.html";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jcumming ehmry ];

    # `Makefile.am` assumes the ability to run the hostPlatform's python binary at build time
    broken = withPython && (with stdenv; !buildPlatform.canExecute hostPlatform);
  };
}
