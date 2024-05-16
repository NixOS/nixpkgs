{ stdenv
, lib
, fetchFromGitHub
, crystal
, wrapGAppsHook4
, desktopToDarwinBundle
, gi-crystal
, gobject-introspection
, libadwaita
, openssl
, libxml2
, pkg-config
, gitUpdater
, _experimental-update-script-combinators
, runCommand
, crystal2nix
, writeShellScript
}:
crystal.buildCrystalPackage rec {
  pname = "Collision";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "GeopJr";
    repo = "Collision";
    rev = "v${version}";
    hash = "sha256-Qxe4ILDdfYfxu95EvKRTvkAOgDIZDiLymBlZouBWn0M=";
  };
  patches = [ ./make.patch ];
  shardsFile = ./shards.nix;

  # Crystal compiler has a strange issue with OpenSSL. The project will not compile due to
  # main_module:(.text+0x6f0): undefined reference to `SSL_library_init'
  # There is an explanation for this https://danilafe.com/blog/crystal_nix_revisited/
  # Shortly, adding pkg-config to buildInputs along with openssl fixes the issue.

  nativeBuildInputs = [ wrapGAppsHook4 pkg-config gobject-introspection gi-crystal ]
    ++ lib.optionals stdenv.isDarwin [ desktopToDarwinBundle ];
  buildInputs = [ libadwaita openssl libxml2 ];

  buildTargets = ["bindings" "build"];

  doCheck = false;
  doInstallCheck = false;

  installTargets = ["desktop" "install"];

  passthru = {
    updateScript = _experimental-update-script-combinators.sequence [
      (gitUpdater { rev-prefix = "v"; })
      (_experimental-update-script-combinators.copyAttrOutputToFile "collision.shardLock" ./shard.lock)
      { command = [ (writeShellScript "update-lock" "cd $1; ${lib.getExe crystal2nix}") ./. ]; supportedFeatures = [ "silent" ]; }
      { command = [ "rm" ./shard.lock ]; supportedFeatures = [ "silent" ]; }
    ];
    shardLock = runCommand "shard.lock" { inherit src; } ''
      cp $src/shard.lock $out
    '';
  };

  meta = with lib; {
    description = "Check hashes for your files";
    homepage = "https://github.com/GeopJr/Collision";
    license = licenses.bsd2;
    mainProgram = "collision";
    maintainers = with maintainers; [ sund3RRR ];
  };
}
