{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  perl,
  procps,
  bash,

  # shell referenced dependencies
  resholve,
  binutils-unwrapped,
  file,
  gnugrep,
  coreutils,
  gnused,
  gnutar,
  iconv,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "lesspipe";
  version = "2.11";

  src = fetchFromGitHub {
    owner = "wofr06";
    repo = "lesspipe";
    rev = "v${version}";
    hash = "sha256-jJrKiRdrargk0JzcPWxBZGyOpMfTIONHG8HNRecazVo=";
  };

  nativeBuildInputs = [
    perl
    makeWrapper
  ];
  buildInputs = [
    perl
    bash
  ];
  strictDeps = true;

  postPatch = ''
    patchShebangs --build configure
    substituteInPlace configure --replace '/etc/bash_completion.d' '/share/bash-completion/completions'
  '';

  configureFlags = [
    "--shell=${bash}/bin/bash"
    "--prefix=/"
  ];
  configurePlatforms = [ ];

  dontBuild = true;

  installFlags = [ "DESTDIR=$(out)" ];

  postInstall = ''
    # resholve doesn't see strings in an array definition
    substituteInPlace $out/bin/lesspipe.sh --replace 'nodash strings' "nodash ${binutils-unwrapped}/bin/strings"

    ${resholve.phraseSolution "lesspipe.sh" {
      scripts = [ "bin/lesspipe.sh" ];
      interpreter = "${bash}/bin/bash";
      inputs = [
        coreutils
        file
        gnugrep
        gnused
        gnutar
        iconv
        procps
        ncurses
      ];
      keep = [
        "$prog"
        "$c1"
        "$c2"
        "$c3"
        "$c4"
        "$c5"
        "$cmd"
        "$colorizer"
        "$HOME"
      ];
      fake = {
        # script guards usage behind has_cmd test function, it's safe to leave these external and optional
        external =
          [
            "cpio"
            "isoinfo"
            "cabextract"
            "bsdtar"
            "rpm2cpio"
            "bsdtar"
            "unzip"
            "ar"
            "unrar"
            "rar"
            "7zr"
            "7za"
            "isoinfo"
            "gzip"
            "bzip2"
            "lzip"
            "lzma"
            "xz"
            "brotli"
            "compress"
            "zstd"
            "lz4"
            "archive_color"
            "bat"
            "batcat"
            "pygmentize"
            "source-highlight"
            "vimcolor"
            "code2color"

            "w3m"
            "lynx"
            "elinks"
            "html2text"
            "dtc"
            "pdftotext"
            "pdftohtml"
            "pdfinfo"
            "ps2ascii"
            "procyon"
            "ccze"
            "mdcat"
            "pandoc"
            "docx2txt"
            "libreoffice"
            "pptx2md"
            "mdcat"
            "xlscat"
            "odt2txt"
            "wvText"
            "antiword"
            "catdoc"
            "broken_catppt"
            "sxw2txt"
            "groff"
            "mandoc"
            "unrtf"
            "dvi2tty"
            "pod2text"
            "perldoc"
            "h5dump"
            "ncdump"
            "matdump"
            "djvutxt"
            "openssl"
            "gpg"
            "plistutil"
            "plutil"
            "id3v2"
            "csvlook"
            "jq"
            "zlib-flate"
            "lessfilter"
          ]
          ++ lib.optional (stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isFreeBSD) [
            # resholve only identifies this on darwin/bsd
            # call site is guarded by || so it's safe to leave dynamic
            "locale"
          ];
        builtin = [ "setopt" ];
      };
      execer = [
        "cannot:${iconv}/bin/iconv"
      ];
    }}
    ${resholve.phraseSolution "lesscomplete" {
      scripts = [ "bin/lesscomplete" ];
      interpreter = "${bash}/bin/bash";
      inputs = [
        coreutils
        file
        gnugrep
        gnused
        gnutar
      ];
      keep = [
        "$prog"
        "$c1"
        "$c2"
        "$c3"
        "$c4"
        "$c5"
        "$cmd"
      ];
      fake = {
        # script guards usage behind has_cmd test function, it's safe to leave these external and optional
        external = [
          "cpio"
          "isoinfo"
          "cabextract"
          "bsdtar"
          "rpm2cpio"
          "bsdtar"
          "unzip"
          "ar"
          "unrar"
          "rar"
          "7zr"
          "7za"
          "isoinfo"
          "gzip"
          "bzip2"
          "lzip"
          "lzma"
          "xz"
          "brotli"
          "compress"
          "zstd"
          "lz4"
        ];
        builtin = [ "setopt" ];
      };
    }}
  '';

  meta = with lib; {
    description = "Preprocessor for less";
    longDescription = ''
      Usually lesspipe.sh is called as an input filter to less. With the help
      of that filter less will display the uncompressed contents of compressed
      (gzip, bzip2, compress, rar, 7-zip, lzip, xz or lzma) files. For files
      containing archives and directories, a table of contents will be
      displayed (e.g tar, ar, rar, jar, rpm and deb formats). Other supported
      formats include nroff, pdf, ps, dvi, shared library, MS word, OASIS
      (e.g. Openoffice), NetCDF, html, mp3, jpg, png, iso images, MacOSX bom,
      plist and archive formats, perl storable data and gpg encrypted files.
      This does require additional helper programs being installed.
    '';
    homepage = "https://github.com/wofr06/lesspipe";
    platforms = platforms.all;
    license = licenses.gpl2Only;
    maintainers = [ maintainers.martijnvermaat ];
  };
}
