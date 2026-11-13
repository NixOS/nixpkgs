import ./generic.nix {
  hash = "sha256-JO6qZvsy3EcMYVXF3SjQljOSAEG1RlQTK+eiQIT9c1s=";
  version = "7.6.0";
  vendorHash = "sha256-3T3NXH3GVfn1K6dfObOji4GCkcYzio8yRfdV5nyOAtE=";
  patches = fetchpatch: [
    # client: Only probe Unix sockets when several exist
    (fetchpatch {
      url = "https://github.com/lxc/incus/commit/d34562e45efe62c8c31523f7c82a508d13f68219.patch";
      hash = "sha256-HrnNuMb9vw5Na97UiZZujdHekTkUOsKnowiHyMBqp5Q=";
    })
    # incus-user: Serialize user setup across connections
    (fetchpatch {
      url = "https://github.com/lxc/incus/commit/ef9a103401c19d26a3def929c310eadfa376bfea.patch";
      hash = "sha256-cTsf+FvG1inYfZDIZAfP61K1YJ3gmUZj5yfkyxL7D54=";
    })
  ];
  nixUpdateExtraArgs = [
    "--override-filename=pkgs/by-name/in/incus/package.nix"
  ];
}
