{
  stdenv,
  lib,
  makeWrapper,
  perl,
  perlPackages,
}:

stdenv.mkDerivation {
  name = "nixpkgs-lint-1";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    perl
    perlPackages.XMLSimple
  ];

  dontUnpack = true;
  buildPhase = "true";

  installPhase = ''
    mkdir -p $out/bin
    cp ${./nixpkgs-lint.pl} $out/bin/nixpkgs-lint
    wrapProgram $out/bin/nixpkgs-lint --set PERL5LIB $PERL5LIB
  '';

  meta = with lib; {
    maintainers = [ maintainers.eelco ];
    description = "A utility for Nixpkgs contributors to check Nixpkgs for common errors";
    mainProgram = "nixpkgs-lint";
    platforms = platforms.unix;
  };
}
