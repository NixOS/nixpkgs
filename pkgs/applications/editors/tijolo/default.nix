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
, _experimental-update-script-combinators
, gitUpdater
, writeShellScript
, crystal2nix
, runCommand
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
    ++ lib.optionals stdenv.isDarwin [ desktopToDarwinBundle ];
  buildInputs = [ gtk4 libadwaita vte-gtk4 libgit2 gtksourceview5 editorconfig-core-c ];

  buildTargets = [ "all" ];
  doCheck = false;

  installTargets = [ "install" "post-install" "install-fonts"];
  doInstallCheck = false;

  passthru = {
    updateScript = _experimental-update-script-combinators.sequence [
      (gitUpdater { rev-prefix = "v"; })
      (_experimental-update-script-combinators.copyAttrOutputToFile "tijolo.shardLock" ./shard.lock)
      { command = [ (writeShellScript "update-lock" "cd $1; ${lib.getExe crystal2nix}") ./. ]; supportedFeatures = [ "silent" ]; }
      { command = [ "rm" ./shard.lock ]; supportedFeatures = [ "silent" ]; }
    ];
    shardLock = runCommand "shard.lock" { inherit src; } ''
      cp $src/shard.lock $out
    '';
  };

  meta = with lib; {
    description = "Lightweight, keyboard-oriented IDE for the masses";
    homepage = "https://github.com/hugopl/tijolo";
    license = licenses.mit;
    mainProgram = "tijolo";
    maintainers = with maintainers; [ sund3RRR ];
  };
}
