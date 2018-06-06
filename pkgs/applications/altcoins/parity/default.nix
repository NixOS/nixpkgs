let
  version     = "1.10.6";
  sha256      = "1x2sm262z8fdkx8zin6r8nwbb7znziw9nm224pr6ap3p0jmv7fcq";
  cargoSha256 = "1wf1lh32f9dlhv810gdcssv92g1yximx09lw63m0mxcjbn9813bs";
  patches     = [ ./patches/vendored-sources-1.10.patch ];
in
  import ./parity.nix { inherit version sha256 cargoSha256 patches; }
