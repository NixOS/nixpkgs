<<<<<<< HEAD
# Perl {#setup-hook-perl}
=======

### Perl {#setup-hook-perl}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

Adds the `lib/site_perl` subdirectory of each build input to the `PERL5LIB` environment variable. For instance, if `buildInputs` contains Perl, then the `lib/site_perl` subdirectory of each input is added to the `PERL5LIB` environment variable.
