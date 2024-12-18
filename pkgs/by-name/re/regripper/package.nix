{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  perl,
  perlPackages,
}:

let
  perlDeps = [
    perlPackages.ParseWin32Registry
  ];
in
stdenv.mkDerivation {
  pname = "regripper";
  version = "0-unstable-2024-11-02";

  src = fetchFromGitHub {
    owner = "keydet89";
    repo = "RegRipper3.0";
    rev = "89f3cac57e10bce1a79627e6038353e8e8a0c378";
    hash = "sha256-dW3Gr4HQH484i47Bg+CEnBYoGQQRMBJr88+YeuU+iV4=";
  };

  nativeBuildInputs = [ makeWrapper ];

  propagatedBuildInputs = [
    perl
  ] ++ perlDeps;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share}

    rm -r *.md *.exe *.bat *.dll *.zip

    cp -aR . "$out/share/regripper/"

    makeWrapper ${perl}/bin/perl $out/bin/regripper \
      --add-flags "$out/share/regripper/rip.pl" \
      --set PERL5LIB ${perlPackages.makeFullPerlPath perlDeps}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Open source forensic software used as a Windows Registry data extraction command line";
    mainProgram = "regripper";
    homepage = "https://github.com/keydet89/RegRipper3.0";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
