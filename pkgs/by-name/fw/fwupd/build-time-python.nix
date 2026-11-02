# Python environment that needs to be able to run the following:
# https://github.com/fwupd/fwupd/blob/f8b5ed554ce3d5e7a016e6e97f0a03e48e510ddb/plugins/uefi-capsule/meson.build#L73

{
  lib,
  glib,
  pango,
  python3,
  harfbuzz,
}:

let
  giTypelibPath = lib.makeSearchPathOutput "out" "lib/girepository-1.0" [
    harfbuzz
    pango
    glib
  ];
in
(python3.withPackages (p: [
  p.jinja2
  p.pygobject3
  p.setuptools
])).override
  {
    makeWrapperArgs = [ "--set GI_TYPELIB_PATH ${giTypelibPath}" ];
  }
