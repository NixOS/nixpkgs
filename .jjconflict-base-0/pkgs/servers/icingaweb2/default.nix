{ stdenvNoCC, lib, fetchFromGitHub, makeWrapper, php, nixosTests }:

stdenvNoCC.mkDerivation rec {
  pname = "icingaweb2";
  version = "2.12.2";

  src = fetchFromGitHub {
    owner = "Icinga";
    repo = "icingaweb2";
    rev = "v${version}";
    hash = "sha256-RwKVANFlFWKgMBwlLmX0P4PR+eTN3uz//kMdJ8dLZuU=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/share
    cp -ra application bin etc library modules public $out
    cp -ra doc $out/share

    wrapProgram $out/bin/icingacli --prefix PATH : "${lib.makeBinPath [ php ]}"
  '';

  passthru.tests = { inherit (nixosTests) icingaweb2; };

  meta = with lib; {
    description = "Webinterface for Icinga 2";
    longDescription = ''
      A lightweight and extensible web interface to keep an eye on your environment.
      Analyse problems and act on them.
    '';
    homepage = "https://www.icinga.com/products/icinga-web-2/";
    license = licenses.gpl2Only;
    maintainers = teams.helsinki-systems.members;
    mainProgram = "icingacli";
    platforms = platforms.all;
  };
}
