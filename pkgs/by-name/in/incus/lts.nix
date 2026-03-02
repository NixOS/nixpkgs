import ./generic.nix {
  hash = "sha256-Sg3+399EgwEcZ8fp9cb2KEWQtBpYr5PkwTdnGl/AdfA";
  version = "6.0.5-unstable-2026-01-23";
  rev = "f8da60633e493bb5c0521981fa031bc909988c95";
  vendorHash = "sha256-KOJqPvp+w7G505ZMJ1weRD2SATmfq1aeyCqmbJ6WMAY=";
  patches = [
    # qemu 9.1 compat, remove when added to LTS
    ./572afb06f66f83ca95efa1b9386fceeaa1c9e11b.patch
    ./0c37b7e3ec65b4d0e166e2127d9f1835320165b8.patch
    # post 6.0.5 patches, remove >= 6.0.6
    # ./c5359c809836c0f3b1e6022bf0528bb90ce06ad7.patch
    # ./57096066959c843e1c413c4a97f64077b95cb397.patch
    # ./f3dc9c0e6b77bb8765b347564702e026c2a8f9c6.patch
    # ./d6a1ea3912938dae740cf821cd070e66e7a623ff.patch
    # ./d6f0a77dd26df4c1ced80ffa63848279fd4330cc.patch
    # ./92ac6ac999a4928cfdb92c485a048e4d51f471d0.patch
    # ./f8da60633e493bb5c0521981fa031bc909988c95,patch
  ];
  lts = true;
  nixUpdateExtraArgs = [
    "--version-regex=^v(6\\.0\\.[0-9]+)$"
    "--override-filename=pkgs/by-name/in/incus/lts.nix"
  ];
}
