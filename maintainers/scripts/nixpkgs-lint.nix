{ wrapCommand, lib, perl, perlPackages }:

wrapCommand "nixpkgs-lint" {
  version = "1";
  buildInputs = [ perl perlPackages.XMLSimple ];
  executable = "${perl}/bin/perl";
  makeWrapperArgs = [ "--set PERL5LIB $PERL5LIB"
                      "--add-flags ${./nixpkgs-lint.pl}" ];
  meta = with lib; {
    maintainers = [ maintainers.eelco ];
    description = "A utility for Nixpkgs contributors to check Nixpkgs for common errors";
    platforms = platforms.unix;
  };
}
