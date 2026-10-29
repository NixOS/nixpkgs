{
  lib,
  callPackage,
  buildNpmPackage,
  imagemagick,
}:

let
  common = callPackage ./common.nix { };
in
buildNpmPackage {
  inherit (common)
    pname
    version
    src
    patches
    ;

  npmDepsHash = "sha256-gvAHUgfS21UrZYUL/QUsAMymqh4g/Moo/+vTl6RH/7I=";

  nativeBuildInputs = [ imagemagick ];

  postInstall = ''
    cp -r priv/static $out/static
  '';

  meta = {
    description = "Frontend for the Mobilizon server";
    homepage = "https://joinmobilizon.org/";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      erictapen
    ];
  };
}
