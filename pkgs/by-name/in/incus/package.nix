import ./generic.nix {
  hash = "sha256-zwefzCmj4K1GJRbherOS28swLoGbHnUxbF9bmLOh738=";
  version = "6.0.4";
  vendorHash = "sha256-4of741V2ztxkyI2r5UVEL5ON/9kaDTygosLxyTw6ShQ=";
  patches = [ ];
  nixUpdateExtraArgs = [
    "--override-filename=pkgs/by-name/in/incus/package.nix"
  ];
}
