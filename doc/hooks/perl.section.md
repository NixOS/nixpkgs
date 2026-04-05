# Perl {#setup-hook-perl}

Adds the `lib/site_perl` subdirectory of each build input to the `PERL5LIB` environment variable. For instance, if `buildInputs` contains Perl, then the `lib/site_perl` subdirectory of each input is added to the `PERL5LIB` environment variable.
