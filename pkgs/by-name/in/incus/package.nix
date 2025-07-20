import ./generic.nix {
  hash = "sha256-py1QqOmcg51T9EQEYBsOP611vCzZhF4AAqcweo9+D/Q=";
  version = "6.14.0";
  vendorHash = "sha256-YRif8fmfXqc5Xn9xI382iko9WUzSucKKqrWEdU0gfSU=";
  patches = [ ];
  nixUpdateExtraArgs = [
    "--override-filename=pkgs/by-name/in/incus/package.nix"
  ];
}
