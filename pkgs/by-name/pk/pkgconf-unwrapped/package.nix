{
  libpkgconf,
  ...
}@args:
# nixpkgs-update: no auto update
libpkgconf.override (removeAttrs args [ "libpkgconf" ])
