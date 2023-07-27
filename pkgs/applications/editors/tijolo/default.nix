{ stdenv
, lib
, fetchFromGitHub
, crystal
, vte
, libgit2
, editorconfig-core-c
, gtksourceview4
, wrapGAppsHook
, desktopToDarwinBundle
}:
crystal.buildCrystalPackage rec {
  pname = "tijolo";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "hugopl";
    repo = "tijolo";
    rev = "v${version}";
    hash = "sha256-15not/B+O+wIZ/fvLFy26/dyvq0E+bZUeoSZ6HxMMKg=";
  };

  nativeBuildInputs = [ wrapGAppsHook ]
    ++ lib.optionals stdenv.isDarwin [ desktopToDarwinBundle ];
  buildInputs = [ vte libgit2 gtksourceview4 editorconfig-core-c ];

  buildTargets = [ "all" ];
  doCheck = false;

  shardsFile = ./tijolo-shards.nix;

  installTargets = [ "install" "install-fonts"];
  doInstallCheck = false;

  meta = with lib; {
    description = "Lightweight, keyboard-oriented IDE for the masses";
    homepage = "https://github.com/hugopl/tijolo";
    license = licenses.mit;
    mainProgram = "tijolo";
    maintainers = with maintainers; [ sund3RRR ];
  };
}
