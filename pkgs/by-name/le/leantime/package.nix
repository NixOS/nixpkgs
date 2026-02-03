{
  php,
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  pkgs,
  nodejs,
}:

let
  version = "v3.6.2";
  src = fetchFromGitHub {
    owner = "Leantime";
    repo = "leantime";
    tag = version;
    hash = "sha256-Fzm0UwqbC3MpD3rVHOuSaYpcd9NXWiaXbaSCFhWwVyA=";
  };
  nodePkg = buildNpmPackage {
    pname = "leantime-assets";
    inherit version;
    inherit src;
    npmDepsHash = "sha256-5krmSWY8Pl9Y4V4ILvx6+BT4Bn26ybuLa0MlMayILAo=";
    npmFlags = [
      "--legacy-peer-deps"
    ];
    dontNpmBuild = true;
    buildPhase = ''
       export PATH="$PWD/node_modules/.bin:$PATH"

      ./node_modules/.bin/mix
    '';
    installPhase = ''
      mkdir -p $out/public
      cp -r public/* $out/public
    '';
  };
in
php.buildComposerProject2 (finalAttrs: {
  pname = "leantime";
  version = version;
  inherit src;

  patches = [
    ./storage.patch
    ./userfiles.patch
  ];

  vendorHash = "sha256-hZxwO/fojh2r6kB3t81Jg37iMujNqqaWI+u64Q15Jj4=";

  postInstall = ''
    rm -rf $out/share/php/leantime/public
    cp -r ${nodePkg}/public $out/share/php/leantime
  '';

  meta = {
    description = "An open source project management system";
    license = lib.licenses.agpl3Only;
    homepage = "https://leantime.io";
    maintainers = with lib.maintainers; [ jordycoding ];
  };
})
