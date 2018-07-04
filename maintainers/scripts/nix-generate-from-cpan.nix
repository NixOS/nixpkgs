{ wrapCommand, lib, perl, perlPackages }:

wrapCommand "nix-generate-from-cpan" {
  version = "3";
  buildInputs = with perlPackages; [
    perl CPANMeta GetoptLongDescriptive CPANPLUS Readonly Log4Perl
  ];
  executable = "${perl}/bin/perl";
  makeWrapperArgs = [ "--set PERL5LIB $PERL5LIB"
                      "--add-flags ${./nix-generate-from-cpan.pl}"];
  meta = with lib; {
    maintainers = with maintainers; [ eelco rycee ];
    description = "Utility to generate a Nix expression for a Perl package from CPAN";
    platforms = platforms.unix;
  };
}
