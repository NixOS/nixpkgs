# OpenXR in NixOS

OpenXR is a standard for eXtended Reality (XR) applications and drivers (providers).

OpenXR runtime providers must ensure that their provided `library_path` can be loaded by Nix applications. If your OpenXR runtime provider runs in a FHSEnv, this means you may have to patch the program to run `autopatchelf` to link dependencies to the Nix store.
