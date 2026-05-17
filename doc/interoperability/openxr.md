# OpenXR in NixOS

OpenXR is a standard for eXtended Reality (XR) applications and drivers (providers).

OpenXR runtime providers must ensure that the library path of the runtime's shared library can be loaded by Nix applications. If your OpenXR runtime provider runs in an FHSEnv, this means you may have to use `auto-patchelf` to link dependencies to the Nix store.
