{
  stdenv,
  lib,
  fetchFromGitHub,
  crystal,
  vte,
  libgit2,
  editorconfig-core-c,
  gtksourceview4,
  wrapGAppsHook3,
  desktopToDarwinBundle,
}:
crystal.buildCrystalPackage rec {
  pname = "tijolo";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "hugopl";
    repo = "tijolo";
    rev = "v${version}";
    hash = "sha256-3TfXvRVP3lu43qF3RWCHnZ3czTaSl5EzrhuTlpnMfKo=";
  };

  nativeBuildInputs = [ wrapGAppsHook3 ] ++ lib.optionals stdenv.isDarwin [ desktopToDarwinBundle ];
  buildInputs = [
    vte
    libgit2
    gtksourceview4
    editorconfig-core-c
  ];

  buildTargets = [ "all" ];
  doCheck = false;

  shardsFile = ./shards.nix;

  installTargets = [
    "install"
    "install-fonts"
  ];
  doInstallCheck = false;

  meta = with lib; {
    description = "Lightweight, keyboard-oriented IDE for the masses";
    homepage = "https://github.com/hugopl/tijolo";
    license = licenses.mit;
    mainProgram = "tijolo";
    maintainers = with maintainers; [ sund3RRR ];
  };
}
