{ lib
, perlPackages
, fetchFromGitHub
, wrapGAppsHook
, gobject-introspection
, perl
, clamav
}:

perlPackages.buildPerlPackage rec {
  pname = "clamtk";
  version = "6.17";

  src = fetchFromGitHub {
    owner = "dave-theunsub";
    repo = "clamtk";
    rev = "v${version}";
    hash = "sha256-2tWVfRijf78OiKBpLUrZWFberIL8mjqtxvW/IjPn1IE=";
  };

  nativeBuildInputs = [ wrapGAppsHook gobject-introspection ];
  buildInputs = [ perl clamav ];
  propagatedBuildInputs = with perlPackages; [ Glib LWP LWPProtocolHttps TextCSV JSON LocaleGettext Gtk3 ];

  preConfigure = "touch Makefile.PL";
  # no tests implemented
  doCheck = false;
  outputs = [ "out" "man" ];

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

    install -D lib/*.pm -t $out/lib/perl5/site_perl/ClamTk
    install -D clamtk.desktop -t $out/share/applications
    install -D images/* -t $out/share/pixmaps
    install -D clamtk.1.gz -t $out/share/man/man1
    install -D -m755 clamtk -t $out/bin

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
    license = licenses.gpl1Plus;
    homepage = "https://github.com/dave-theunsub/clamtk";
    platforms = platforms.linux;
    maintainers = with maintainers; [ chewblacka ShamrockLee ];
  };

}
