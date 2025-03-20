{
  pname,
  version,
  src,
  gitSrc,
  buildInputs ? [ ],
  homepage,
  description,
  maintainers,
  passthru ? { },
}:

{
  lib,
  stdenv,
  openssl,
  zlib,
  asciidoc,
  libxml2,
  libxslt,
  docbook_xsl,
  pkg-config,
  coreutils,
  gnused,
  groff,
  docutils,
  gzip,
  bzip2,
  lzip,
  xz,
  zstd,
  python3Packages,
}:

stdenv.mkDerivation {
  inherit
    pname
    version
    src
    gitSrc
    passthru
    ;

  separateDebugInfo = true;

  nativeBuildInputs =
    [
      pkg-config
      asciidoc
    ]
    ++ (with python3Packages; [
      python
      wrapPython
    ]);
  buildInputs = buildInputs ++ [
    openssl
    zlib
    libxml2
    libxslt
    docbook_xsl
  ];
  pythonPath = with python3Packages; [
    pygments
    markdown
  ];

  postPatch = ''
    sed -e 's|"gzip"|"${gzip}/bin/gzip"|' \
        -e 's|"bzip2"|"${bzip2.bin}/bin/bzip2"|' \
        -e 's|"lzip"|"${lzip}/bin/lzip"|' \
        -e 's|"xz"|"${xz.bin}/bin/xz"|' \
        -e 's|"zstd"|"${zstd}/bin/zstd"|' \
        -i ui-snapshot.c

    substituteInPlace filters/html-converters/man2html \
      --replace 'groff' '${groff}/bin/groff'

    substituteInPlace filters/html-converters/rst2html \
      --replace 'rst2html.py' '${docutils}/bin/rst2html.py'
  '';

  # Give cgit a git source tree and pass configuration parameters (as make
  # variables).
  preBuild = ''
    mkdir -p git
    tar --strip-components=1 -xf "$gitSrc" -C git
  '';

  makeFlags = [
    "prefix=$(out)"
    "CGIT_SCRIPT_PATH=$(out)/cgit/"
    "CC=${stdenv.cc.targetPrefix}cc"
    "AR=${stdenv.cc.targetPrefix}ar"
  ];

  # Install manpage.
  postInstall = ''
    # xmllint fails:
    #make install-man

    # bypassing xmllint works:
    a2x --no-xmllint -f manpage cgitrc.5.txt
    mkdir -p "$out/share/man/man5"
    cp cgitrc.5 "$out/share/man/man5"

    wrapPythonProgramsIn "$out/lib/cgit/filters" "$out $pythonPath"

    for script in $out/lib/cgit/filters/*.sh $out/lib/cgit/filters/html-converters/txt2html; do
      wrapProgram $script --prefix PATH : '${
        lib.makeBinPath [
          coreutils
          gnused
        ]
      }'
    done
  '';

  stripDebugList = [ "cgit" ];

  enableParallelBuilding = true;

  meta = {
    inherit homepage description;
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = maintainers ++ (with lib.maintainers; [ qyliss ]);
  };
}
