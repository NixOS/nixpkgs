{ stdenv, lib, buildGoPackage, trousers, dclxvi, wrapGAppsHook, pkgconfig, gtk3, gtkspell3,
  fetchgit, fetchhg, fetchbzr, fetchsvn }:

let
  isx86_64 = stdenv.lib.any (n: n == stdenv.system) stdenv.lib.platforms.x86_64;
  gui = true; # Might be implemented with nixpkgs config.
in
buildGoPackage rec {
  name = "pond-${version}";
  version = "20150830-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "bce6e0dc61803c23699c749e29a83f81da3c41b2";

  goPackagePath = "github.com/agl/pond";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/agl/pond";
    sha256 = "1dmgbg4ak3jkbgmxh0lr4hga1nl623mh7pvsgby1rxl4ivbzwkh4";
  };

  goDeps = ./deps.json;

  buildInputs = [ trousers pkgconfig gtk3 gtkspell3 ]
    ++ stdenv.lib.optional isx86_64 dclxvi
    ++ stdenv.lib.optionals gui [ wrapGAppsHook ];
  buildFlags = stdenv.lib.optionalString (!gui) "-tags nogui";
  excludedPackages = "\\(appengine\\|bn256cgo\\)";
  postPatch = stdenv.lib.optionalString isx86_64 ''
    grep -r 'bn256' | awk -F: '{print $1}' | xargs sed -i \
      -e "s,golang.org/x/crypto/bn256,github.com/agl/pond/bn256cgo,g" \
      -e "s,bn256\.,bn256cgo.,g"
  '';
}
