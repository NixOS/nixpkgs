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
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "hugopl";
    repo = "tijolo";
    rev = "v${version}";
    hash = "sha256-RVdZce9csnhJx5p+jBANDCsz2eB/l3EHExwKMbKL9y0=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "shards install" "true"
  '';

  shardsFile = ./shards.nix;
  copyShardDeps = true;

  preBuild = ''
    cd lib/gi-crystal && shards build -Dpreview_mt --release --no-debug
    cd ../.. && mkdir bin/ && cp lib/gi-crystal/bin/gi-crystal bin/
  '';

  nativeBuildInputs = [ wrapGAppsHook4 gobject-introspection ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ desktopToDarwinBundle ];
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
