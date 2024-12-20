{
  stdenv,
  lib,
  makeWrapper,
  perl,
  perlPackages,
}:

stdenv.mkDerivation {
  pname = "nixpkgs-lint";
  version = "1";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    perl
    perlPackages.XMLSimple
  ];

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp ${./nixpkgs-lint.pl} $out/bin/nixpkgs-lint
    # make the built version hermetic
    substituteInPlace  $out/bin/nixpkgs-lint \
      --replace-fail "#! /usr/bin/env nix-shell" "#! ${lib.getExe perl}"
    wrapProgram $out/bin/nixpkgs-lint --set PERL5LIB $PERL5LIB
  '';

  meta = with lib; {
    maintainers = [ maintainers.eelco ];
    description = "A utility for Nixpkgs contributors to check Nixpkgs for common errors";
    mainProgram = "nixpkgs-lint";
    platforms = platforms.unix;
  };
}
