{ lib, stdenv, buildGoPackage, trousers, dclxvi, wrapGAppsHook, pkg-config, gtk3, gtkspell3,
  fetchFromGitHub }:

let
  gui = true; # Might be implemented with nixpkgs config.
in
buildGoPackage rec {
  pname = "pond";
  version = "unstable-2015-08-30";

  goPackagePath = "github.com/agl/pond";

  src = fetchFromGitHub {
    owner = "agl";
    repo = "pond";
    rev = "bce6e0dc61803c23699c749e29a83f81da3c41b2";
    sha256 = "sha256-BE7+146E9hz8enrfA+sQhtqgHiSZAtjrW1OOqchbr7Y=";
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
