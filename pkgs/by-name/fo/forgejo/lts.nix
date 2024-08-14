import ./generic.nix {
  version = "7.0.7";
  hash = "sha256-Xk5ElAfTjbz77Jv5VMbSW7q8qJ5vhNd3daNilNzDsY4=";
  npmDepsHash = "sha256-OqtYRjftwGxgW1JgMxyWd+9DndpEkd3LdQHSECc40yU=";
  vendorHash = "sha256-hfbNyCQMQzDzJxFc2MPAR4+v/qNcnORiQNbwbbIA4Nw=";
  lts = true;
  nixUpdateExtraArgs = [
    "--version-regex"
    "v(7\.[0-9.]+)"
    "--override-filename"
    "pkgs/by-name/fo/forgejo/lts.nix"
  ];
}
