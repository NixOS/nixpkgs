import ./generic.nix {
  version = "7.0.8";
  hash = "sha256-m6yToQQFM+4g8xhs572O4n4r06xeS3DozYHtAKwMjUg=";
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
