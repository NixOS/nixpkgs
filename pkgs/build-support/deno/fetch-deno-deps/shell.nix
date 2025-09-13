let
  inherit (import ../../../../default.nix { }) pkgs;

in
pkgs.mkShell {
  buildInputs = with pkgs; [
    deno
    rustup
  ];

  DENO_DIR = "./.deno";
  shellHook = '''';
}
