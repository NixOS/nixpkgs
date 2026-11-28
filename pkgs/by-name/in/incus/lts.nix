import ./generic.nix {
  hash = "sha256-sq2Ed07yPlOuO7l29v7T6zb1ZVeBfbA6z14+jxQ7K4E=";
  version = "7.0.2-unstable-2026-11-27";
  vendorHash = "sha256-n4b6XAmkrO4Mgd05cr1apcRCC1eKeRsZTX0AKvWcX8Q=";
  rev = "11c8e7c9620c1e282d87e0e26ea04a20dd06fa46";
  lts = true;
  nixUpdateExtraArgs = [
    "--version-regex=^v(7\\.0\\.[0-9]+)$"
    "--override-filename=pkgs/by-name/in/incus/lts.nix"
  ];
}
