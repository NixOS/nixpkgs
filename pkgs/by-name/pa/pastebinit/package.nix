{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  libxslt,
  docbook_xsl,
  installShellFiles,
  callPackage,
}:
stdenv.mkDerivation rec {
  version = "1.6.2";
  pname = "pastebinit";

  src = fetchFromGitHub {
    owner = "pastebinit";
    repo = "pastebinit";
    rev = version;
    hash = "sha256-vuAWkHlQM6QTWarThpSbY0qrxzej0GvLU0jT2JOS/qc=";
  };

  patches = [
    ./use-drv-etc.patch
  ];

  nativeBuildInputs = [
    libxslt
    installShellFiles
  ];

  buildInputs = [
    (python3.withPackages (p: [ p.distro ]))
  ];

  buildPhase = ''
    xsltproc --nonet ${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl pastebinit.xml
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/etc
    cp -a pastebinit $out/bin
    cp -a utils/* $out/bin
    cp -a pastebin.d $out/etc
    substituteInPlace $out/bin/pastebinit --subst-var-by "etc" "$out/etc"
    installManPage pastebinit.1
  '';

  meta = {
    homepage = "https://stgraber.org/category/pastebinit/";
    description = "Software that lets you send anything you want directly to a pastebin from the command line";
    maintainers = with lib.maintainers; [
      raboof
      samuel-martineau
    ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
