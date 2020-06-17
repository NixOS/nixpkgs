{ stdenv
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
  version = "2020-05-20";

  src = fetchFromGitHub {
    owner = "trizen";
    repo = pname;
    rev = "ed9a680546edbb5b05086971b6a9f42a37cb485f";
    sha256 = "1fikdl08a0s8d6k1ls1pzmw2rcwkfbbczsjfx6lr12ngd2bz222h";
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

  meta = with stdenv.lib; {
    homepage = "https://github.com/trizen/fbmenugen";
    description = "Simple menu generator for the Fluxbox Window Manager";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
