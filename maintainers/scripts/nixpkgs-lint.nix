{ stdenv, makeWrapper, perl, perlPackages }:

stdenv.mkDerivation {
  name = "nixpkgs-lint-1";

  buildInputs = [ makeWrapper perl perlPackages.XMLSimple ];

  unpackPhase = "true";
  buildPhase = "true";

  installPhase =
    ''
      mkdir -p $out/bin
      cp ${./nixpkgs-lint.pl} $out/bin/nixpkgs-lint
      wrapProgram $out/bin/nixpkgs-lint --set PERL5LIB $PERL5LIB
    '';

  meta = {
    maintainers = [ stdenv.lib.maintainers.eelco ];
    description = "A utility for Nixpkgs contributors to check Nixpkgs for common errors";
    platforms = stdenv.lib.platforms.unix;
  };
}
