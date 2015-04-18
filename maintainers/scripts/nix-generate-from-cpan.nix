{ stdenv, makeWrapper, perl, perlPackages }:

stdenv.mkDerivation {
  name = "nix-generate-from-cpan-1";

  buildInputs = [ makeWrapper perl perlPackages.YAMLLibYAML perlPackages.JSON perlPackages.CPANPLUS ];

  unpackPhase = "true";
  buildPhase = "true";

  installPhase =
    ''
      mkdir -p $out/bin
      cp ${./nix-generate-from-cpan.pl} $out/bin/nix-generate-from-cpan
      wrapProgram $out/bin/nix-generate-from-cpan --set PERL5LIB $PERL5LIB
    '';

  meta = {
    maintainers = [ stdenv.lib.maintainers.eelco ];
    description = "Utility to generate a Nix expression for a Perl package from CPAN";
  };
}
