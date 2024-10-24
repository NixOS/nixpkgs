{
  lib,
  callPackage,
  fetchFromGitea,
  autoPatchelfHook,
  zlib,

  symlinkJoin,
  fetchFromGitHub,
  glbinding,
  assimp,
  xorg,
}:
callPackage (import ./generic.nix {
  pname = "doomsday-engine3";
  version = "3.0-unstable-2021-08-07";

  src = fetchFromGitea {
    domain = "git.skyjake.fi";
    owner = "doomsday";
    repo = "engine";
    rev = "db4bb26129d6fca8dcd58ba2a058dc73eaa3ef86";
    hash = "sha256-tox5c4UPfq5tNBLkD/ebHMiWpDN18WDuZRKzFzekwJQ=";
  };

  gamekitPath = "libs/gamekit/libs";

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ zlib ];

  preConfigure =
    let
      # Doomsday Engine 3.x currently depends on some *really* old deps...
      # They have to be symlinked to the right path, too...
      vendoredDeps = symlinkJoin {
        name = "doomsday-vendored-deps";
        paths = [
          (glbinding.overrideAttrs (final: prev: {
            version = "2.1.4";
            src = fetchFromGitHub {
              inherit (prev.src) owner repo;
              rev = "v${final.version}";
              hash = "sha256-n/7xJpYgjW3iwjlh7aMrHSvF9umUYSszP6x/HMUdLPo=";
            };
            buildInputs = prev.buildInputs ++ [ xorg.libX11 ];
          }))
          (assimp.overrideAttrs (final: prev: {
            version = "4.1.0";
            src = fetchFromGitHub {
              inherit (prev.src) owner repo;
              rev = "v${final.version}";
              hash = "sha256-mTCK3Rud8Fwl8wtWSqTakYr7Tkd1X2bl/9rVHscL5gE=";
            };
            outputs = [ "out" ]; # Assimp 4.x doesn't have the lib output
            cmakeFlags = [
              (lib.cmakeFeature "ASSIMP_BUILD_ASSIMP_TOOLS" "OFF")
              (lib.cmakeFeature "ASSIMP_BUILD_TESTS" "OFF")
            ];
          }))
        ];
      };
    in
    ''
      mkdir deps
      ln -s ${vendoredDeps} deps/products
    '';
}) { }
