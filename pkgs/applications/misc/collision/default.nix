{
  stdenv,
  lib,
  fetchFromGitHub,
  crystal,
  wrapGAppsHook4,
  desktopToDarwinBundle,
  gobject-introspection,
  nautilus-python,
  python3,
  libadwaita,
  openssl,
  libxml2,
  pkg-config,
  gitUpdater,
  _experimental-update-script-combinators,
  runCommand,
  crystal2nix,
  writeShellScript,
}:

crystal.buildCrystalPackage rec {
  pname = "Collision";
  version = "3.9.0";

  src = fetchFromGitHub {
    owner = "GeopJr";
    repo = "Collision";
    rev = "v${version}";
    hash = "sha256-c/74LzDM63w5zW8z2T8o4Efvuzj791/zTSKEDN32uak=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail 'gtk-update-icon-cache $(PREFIX)/share/icons/hicolor' 'true'
  '';

  shardsFile = ./shards.nix;
  copyShardDeps = true;

  preBuild = ''
    cd lib/gi-crystal && shards build -Dpreview_mt --release --no-debug
    cd ../.. && mkdir bin/ && cp lib/gi-crystal/bin/gi-crystal bin/
  '';

  # Crystal compiler has a strange issue with OpenSSL. The project will not compile due to
  # main_module:(.text+0x6f0): undefined reference to `SSL_library_init'
  # There is an explanation for this https://danilafe.com/blog/crystal_nix_revisited/
  # Shortly, adding pkg-config to buildInputs along with openssl fixes the issue.

  nativeBuildInputs = [
    wrapGAppsHook4
    pkg-config
    gobject-introspection
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ desktopToDarwinBundle ];

  buildInputs = [
    libadwaita
    openssl
    libxml2
    nautilus-python
    python3.pkgs.pygobject3
  ];

  buildTargets = [
    "bindings"
    "build"
  ];

  doCheck = false;
  doInstallCheck = false;

  installTargets = [
    "desktop"
    "install"
  ];

  postInstall = ''
    install -Dm555 ./nautilus-extension/collision-extension.py -t $out/share/nautilus-python/extensions
  '';

  passthru = {
    updateScript = _experimental-update-script-combinators.sequence [
      (gitUpdater { rev-prefix = "v"; })
      (_experimental-update-script-combinators.copyAttrOutputToFile "collision.shardLock" ./shard.lock)
      {
        command = [
          (writeShellScript "update-lock" "cd $1; ${lib.getExe crystal2nix}")
          ./.
        ];
        supportedFeatures = [ "silent" ];
      }
      {
        command = [
          "rm"
          ./shard.lock
        ];
        supportedFeatures = [ "silent" ];
      }
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
    maintainers = with maintainers; [ sund3RRR ] ++ lib.teams.gnome-circle.members;
  };
}
