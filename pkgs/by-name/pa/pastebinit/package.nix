{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  libxslt,
  docbook_xsl,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pastebinit";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "pastebinit";
    repo = "pastebinit";
    tag = finalAttrs.version;
    hash = "sha256-9cPo4yI0VEl1F5TB+Kl7qdpijnOVpuQm2WfsAd9bMSw=";
  };

  postPatch = ''
    substituteInPlace pastebinit \
      --replace-fail "['/usr/share', '/usr/local/share']" "['@etc@', '/usr/share', '/usr/local/share']"
  '';

  nativeBuildInputs = [
    libxslt
    installShellFiles
  ];

  buildInputs = [
    (python3.withPackages (p: [ p.distro ]))
  ];

  buildPhase = ''
    runHook preBuild

    xsltproc --nonet ${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl pastebinit.xml

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/etc
    cp -a pastebinit $out/bin
    cp -a utils/* $out/bin
    cp -a pastebin.d $out/etc
    substituteInPlace $out/bin/pastebinit --subst-var-by "etc" "$out/etc"
    installManPage pastebinit.1

    runHook postInstall
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
})
