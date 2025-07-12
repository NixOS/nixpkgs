{
  callPackage,
  stdenvNoCC,
  # fallback to binary package on Darwin until build is fixed
  fromSource ? !stdenvNoCC.hostPlatform.isDarwin,
  ...
}@args:

callPackage (if fromSource then ./source/package.nix else ./bin/package.nix) (
  removeAttrs args [
    "callPackage"
    "stdenvNoCC"
    "fromSource"
  ]
)
