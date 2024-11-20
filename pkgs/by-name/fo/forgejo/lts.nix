import ./generic.nix {
  version = "7.0.11";
  hash = "sha256-l2HuTwUu/hl86qsIw0F1AI3gYDy/WOZvg7kDP7dYHLE=";
  npmDepsHash = "sha256-suPR7qcxXuK8AJfk47EcQRWtSo5V3jad4Ci122lbBR0=";
  vendorHash = "sha256-hfbNyCQMQzDzJxFc2MPAR4+v/qNcnORiQNbwbbIA4Nw=";
  lts = true;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/lts.nix"
  ];
}
