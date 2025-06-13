{
  lib,
  stdenv,
}:

self: super: {
  # The SDK includes man pages for basic command-line utilities
  # shipped with macOS as well as others that may conflict with
  # those provided by Nixpkgs.
  #
  # We split them out into a separate output to prevent poluting
  # devShells. Furthermore, we name this output `sdkman` rather than
  # the regular `man`/`devman` in preparation for this issue being
  # solved:
  #
  # <https://github.com/NixOS/nix/issues/9550>
  outputs = (super.outputs or [ "out" ]) ++ [ "sdkman" ];
  outputMan = "sdkman";

  buildPhase =
    super.buildPhase or ""
    + ''
      if [[ -d "usr/share/man" ]]; then
        echo "Moving man pages to sdkman output"
        mkdir -p "$sdkman/share"
        mv usr/share/man $sdkman/share/
      fi
    '';
}
