let
  inherit (import ../../../../default.nix { }) pkgs;

in
pkgs.mkShell {
  buildInputs = [
    pkgs.deno
    pkgs.rustup
  ];

  DENO_DIR = "./.deno";
  shellHook = '''';
}
