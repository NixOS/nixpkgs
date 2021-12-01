{ lib, stdenv, buildGoPackage, trousers, dclxvi, wrapGAppsHook, pkg-config, gtk3, gtkspell3,
  fetchgit }:

let
  gui = true; # Might be implemented with nixpkgs config.
in
buildGoPackage rec {
  pname = "pond";
  version = "20150830-${lib.strings.substring 0 7 rev}";
  rev = "bce6e0dc61803c23699c749e29a83f81da3c41b2";

  goPackagePath = "github.com/agl/pond";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/agl/pond";
    sha256 = "1dmgbg4ak3jkbgmxh0lr4hga1nl623mh7pvsgby1rxl4ivbzwkh4";
  };

  goDeps = ./deps.nix;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ trousers gtk3 gtkspell3 ]
    ++ lib.optional stdenv.hostPlatform.isx86_64 dclxvi
    ++ lib.optionals gui [ wrapGAppsHook ];
  tags = lib.optionals (!gui) [ "nogui" ];
  excludedPackages = "\\(appengine\\|bn256cgo\\)";
  postPatch = lib.optionalString stdenv.hostPlatform.isx86_64 ''
    grep -r 'bn256' | awk -F: '{print $1}' | xargs sed -i \
      -e "s,golang.org/x/crypto/bn256,github.com/agl/pond/bn256cgo,g" \
      -e "s,bn256\.,bn256cgo.,g"
  '';

  # https://hydra.nixos.org/build/150102618/nixlog/2
  meta.broken = stdenv.isAarch64;
}
