{ mkDerivation, lib, srcs }:

args:

let
  inherit (args) name;
  sname = args.sname or name;
  inherit (srcs."${sname}") src version;
in
mkDerivation (args // {
  name = "${name}-${version}";
  inherit src;

  outputs = args.outputs or [ "out" "dev" ];

  meta = {
    platforms = lib.platforms.linux;
    homepage = "http://www.kde.org";
  } // (args.meta or {});
})
