{ stdenv
, lib
, fetchFromGitHub
, crystal
, vte-gtk4
, libgit2
, gtk4
, libadwaita
, editorconfig-core-c
, gtksourceview5
, wrapGAppsHook4
, gobject-introspection
, desktopToDarwinBundle
}:
crystal.buildCrystalPackage rec {
  pname = "tijolo";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "hugopl";
    repo = "tijolo";
    rev = "v${version}";
    hash = "sha256-+sRcS5bVH6WLmSDLiPw608OB6OjBVwLqWxGT5Y6caBc=";
  };

  shardsFile = ./shards.nix;
  copyShardDeps = true;

  patches = [ ./make.patch ];

  nativeBuildInputs = [ wrapGAppsHook4 gobject-introspection ]
    ++ lib.optionals stdenv.isDarwin [ desktopToDarwinBundle ];
  buildInputs = [ gtk4 libadwaita vte-gtk4 libgit2 gtksourceview5 editorconfig-core-c ];

  buildTargets = [ "all" ];
  doCheck = false;

  installTargets = [ "install" "post-install" "install-fonts"];
  doInstallCheck = false;

  meta = with lib; {
    description = "Lightweight, keyboard-oriented IDE for the masses";
    homepage = "https://github.com/hugopl/tijolo";
    license = licenses.mit;
    mainProgram = "tijolo";
    maintainers = with maintainers; [ sund3RRR ];
  };
}
