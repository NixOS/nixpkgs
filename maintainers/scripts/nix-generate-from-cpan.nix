{ stdenv, makeWrapper, perl, perlPackages }:

stdenv.mkDerivation {
  name = "nix-generate-from-cpan-2";

  buildInputs = with perlPackages; [
    makeWrapper perl CPANMeta GetoptLongDescriptive CPANPLUS Readonly Log4Perl
  ];

  phases = [ "installPhase" ];

  installPhase =
    ''
      mkdir -p $out/bin
      cp ${./nix-generate-from-cpan.pl} $out/bin/nix-generate-from-cpan
      patchShebangs $out/bin/nix-generate-from-cpan
      wrapProgram $out/bin/nix-generate-from-cpan --set PERL5LIB $PERL5LIB
    '';

  meta = {
    maintainers = with stdenv.lib.maintainers; [ eelco rycee ];
    description = "Utility to generate a Nix expression for a Perl package from CPAN";
  };
}
