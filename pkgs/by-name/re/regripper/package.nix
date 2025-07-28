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
  version = "0-unstable-2024-12-12";

  src = fetchFromGitHub {
    owner = "keydet89";
    repo = "RegRipper3.0";
    rev = "bdf7ac2500a41319479846fe07202b7e8a61ca1f";
    hash = "sha256-JEBwTpDck0w85l0q5WjF1d20NyU+GJ89yAzbkUVOsu0=";
  };

  nativeBuildInputs = [ makeWrapper ];

  propagatedBuildInputs = [
    perl
  ]
  ++ perlDeps;

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
