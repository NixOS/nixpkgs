# nixos-cleanup - free up disk space on the NixOS root partition
#
# Nixpkgs-compatible package definition (pkgs/by-name layout).
#
# The source script carries a `#!/usr/bin/env nix-shell` shebang so it also
# runs standalone on any NixOS; here we re-point the shebang at the packaged
# python3 and drop the nix-shell line so the installed binary needs nothing
# from PATH or channels.
{
  lib,
  stdenv,
  python3,
}:

stdenv.mkDerivation {
  pname = "nixos-cleanup";
  version = "0.1.0";

  src = ./nixos-cleanup.py;

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -D -m755 "$src" "$out/bin/nixos-cleanup"
    sed -i '1s|.*|#!${python3}/bin/python3|' "$out/bin/nixos-cleanup"
    sed -i '2{/^#! nix-shell/d;}' "$out/bin/nixos-cleanup"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Free up disk space on the NixOS root partition";
    homepage = "https://github.com/MulpinKR/nixos-cleanup";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = [
      {
        name = "MulpinKR";
        email = "derkaca751@gmail.com";
      }
    ];
    mainProgram = "nixos-cleanup";
  };
}
