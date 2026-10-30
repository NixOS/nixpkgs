import ./generic.nix {
  hash = "sha256-JO6qZvsy3EcMYVXF3SjQljOSAEG1RlQTK+eiQIT9c1s=";
  version = "7.6.0";
  vendorHash = "sha256-3T3NXH3GVfn1K6dfObOji4GCkcYzio8yRfdV5nyOAtE=";
  nixUpdateExtraArgs = [
    "--override-filename=pkgs/by-name/in/incus/package.nix"
  ];
}
