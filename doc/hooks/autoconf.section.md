<<<<<<< HEAD
# Autoconf {#setup-hook-autoconf}
=======

### Autoconf {#setup-hook-autoconf}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

The `autoreconfHook` derivation adds `autoreconfPhase`, which runs autoreconf, libtoolize and automake, essentially preparing the configure script in autotools-based builds. Most autotools-based packages come with the configure script pre-generated, but this hook is necessary for a few packages and when you need to patch the package’s configure scripts.
