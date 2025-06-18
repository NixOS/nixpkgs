# desktop-file-utils {#desktop-file-utils}

This setup hook removes the MIME cache (located at `$out/share/applications/mimeinfo.cache`) in the `preFixupPhase`.

This hook is necessary because `mimeinfo.cache` can be created when a package uses `desktop-file-utils`, resulting in collisions if multiple packages are installed that contain this file (as in [#48295](https://github.com/NixOS/nixpkgs/issues/48295)).
