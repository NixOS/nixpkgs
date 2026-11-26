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
    ;

  npmDepsHash = "sha256-2cMsZPSDCBXx/U+ymOImHpoBBQ4rs69dbL3bZBA0dY0=";

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
