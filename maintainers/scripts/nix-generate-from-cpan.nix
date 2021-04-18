{ stdenv, lib, makeWrapper, perl, perlPackages }:

stdenv.mkDerivation {
  name = "nix-generate-from-cpan-3";

  buildInputs = with perlPackages; [
    makeWrapper perl GetoptLongDescriptive CPANPLUS Readonly LogLog4perl
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
    maintainers = with lib.maintainers; [ eelco ];
    description = "Utility to generate a Nix expression for a Perl package from CPAN";
    platforms = lib.platforms.unix;
  };
}
