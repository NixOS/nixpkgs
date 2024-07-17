{
  lib,
  perlPackages,
  fetchFromGitHub,
  wrapGAppsHook3,
  gobject-introspection,
  perl,
  clamav,
}:

perlPackages.buildPerlPackage rec {
  pname = "clamtk";
  version = "6.18";

  src = fetchFromGitHub {
    owner = "dave-theunsub";
    repo = "clamtk";
    rev = "v${version}";
    hash = "sha256-ClBsBXbGj67zgrkA9EjgK7s3OmXOJA+xV5xLGOcMsbI=";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
  ];
  buildInputs = [
    perl
    clamav
  ];
  propagatedBuildInputs = with perlPackages; [
    Glib
    LWP
    LWPProtocolHttps
    TextCSV
    JSON
    LocaleGettext
    Gtk3
  ];

  preConfigure = "touch Makefile.PL";
  # no tests implemented
  doCheck = false;
  outputs = [
    "out"
    "man"
  ];

  postPatch = ''
    # Set correct nix paths in perl scripts
    substituteInPlace lib/App.pm \
      --replace /usr/bin/freshclam ${lib.getBin clamav}/bin/freshclam \
      --replace /usr/bin/sigtool ${lib.getBin clamav}/bin/sigtool \
      --replace /usr/bin/clamscan ${lib.getBin clamav}/bin/clamscan \
      --replace /usr/bin/clamdscan ${lib.getBin clamav}/bin/clamdscan \
      --replace /usr/share/pixmaps $out/share/pixmaps

    # We want to catch the crontab wrapper on NixOS and the
    # System crontab on non-NixOS so we don't give a full path.
    substituteInPlace lib/Schedule.pm \
      --replace "( -e '/usr/bin/crontab' )" "(1)" \
      --replace /usr/bin/crontab crontab
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 clamtk -t $out/bin
    install -Dm444 lib/*.pm -t $out/lib/perl5/site_perl/ClamTk
    install -Dm444 clamtk.desktop -t $out/share/applications
    install -Dm444 images/* -t $out/share/pixmaps
    install -Dm444 clamtk.1.gz -t $out/share/man/man1
    install -Dm444 {CHANGES,LICENSE,*.md} -t $out/share/doc/clamtk

    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PERL5LIB : $PERL5LIB
      --set GI_TYPELIB_PATH "$GI_TYPELIB_PATH"
    )
  '';

  meta = with lib; {
    description = ''
      Easy to use, lightweight front-end for ClamAV (Clam Antivirus).
    '';
    mainProgram = "clamtk";
    license = licenses.gpl1Plus;
    homepage = "https://github.com/dave-theunsub/clamtk";
    platforms = platforms.linux;
    maintainers = with maintainers; [
      chewblacka
      ShamrockLee
    ];
  };

}
