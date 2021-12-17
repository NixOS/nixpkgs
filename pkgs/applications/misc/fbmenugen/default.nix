{ lib
, fetchFromGitHub
, fluxbox
, gnused
, makeWrapper
, perlPackages
, substituteAll
, xorg
, wrapGAppsHook
}:

perlPackages.buildPerlPackage rec {
  pname = "fbmenugen";
  version = "0.86";

  src = fetchFromGitHub {
    owner = "trizen";
    repo = pname;
    rev = version;
    sha256 = "0ya7s8b5xbaplz365bnr580szxxsngrs2n7smj8vz8a7kwi0319q";
  };

  patches = [
    (substituteAll {
      src = ./0001-Fix-paths.patch;
      xmessage = xorg.xmessage;
      inherit fluxbox gnused;
    })
  ];

  outputs = [ "out" ];

  nativeBuildInputs = [
    makeWrapper
    wrapGAppsHook
  ];

  buildInputs = [
    fluxbox
    gnused
    perlPackages.DataDump
    perlPackages.FileDesktopEntry
    perlPackages.Gtk3
    perlPackages.LinuxDesktopFiles
    perlPackages.perl
    xorg.xmessage
  ];

  dontConfigure = true;

  dontBuild = true;

  postPatch = ''
    substituteInPlace fbmenugen --subst-var-by fbmenugen $out
  '';

  installPhase = ''
    runHook preInstall
    install -D -t $out/bin ${pname}
    install -D -t $out/etc/xdg/${pname} schema.pl
    runHook postInstall
  '';

  postFixup = ''
    wrapProgram "$out/bin/${pname}" --prefix PERL5LIB : "$PERL5LIB"
  '';

  meta = with lib; {
    homepage = "https://github.com/trizen/fbmenugen";
    description = "Simple menu generator for the Fluxbox Window Manager";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
