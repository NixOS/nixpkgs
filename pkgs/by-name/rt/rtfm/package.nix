{
  stdenv,
  lib,
  fetchFromGitHub,
  crystal,
  wrapGAppsHook4,
  gobject-introspection,
  desktopToDarwinBundle,
  webkitgtk_6_0,
  sqlite,
  libadwaita,
  gtk4,
  glib,
  pango,
  symlinkJoin,
  gitUpdater,
  _experimental-update-script-combinators,
  runCommand,
  crystal2nix,
  writeShellScript,
}:
let
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "hugopl";
    repo = "rtfm";
    tag = "v${version}";
    hash = "sha256-0yKldVTZdFV1Tj1MUI7TCqF3Ho/D7NOGR9UuLaLUFdo=";
  };

  gtk-doc =
    let
      gtk4' = gtk4.override { x11Support = true; };
      pango' = pango.override { withIntrospection = true; };
    in
    symlinkJoin {
      name = "gtk-doc";
      paths = [
        gtk4'.devdoc
        pango'.devdoc
        glib.devdoc
        libadwaita.devdoc
        webkitgtk_6_0.devdoc
      ];
    };
in
crystal.buildCrystalPackage {
  pname = "rtfm";
  inherit version src;

  shardsFile = ./shards.nix;
  copyShardDeps = true;

  postPatch = ''
    substituteInPlace src/doc2dash/create_gtk_docset.cr \
      --replace-fail 'basedir = Path.new("/usr/share/doc")' 'basedir = Path.new(ARGV[0]? || "${gtk-doc}/share/doc")' \
      --replace-fail 'webkit2gtk-4.0' 'webkitgtk-6.0'
    substituteInPlace src/doc2dash/create_crystal_docset.cr \
      --replace-fail 'doc_source = Path.new(ARGV[0]? || "/usr/share/doc/crystal/api")' 'doc_source = Path.new(ARGV[0]? || "${crystal}/share/doc/crystal/api")'
    substituteInPlace src/doc2dash/docset_builder.cr \
      --replace-fail 'File.copy(original, real_dest)' 'File.copy(original, real_dest); File.chmod(real_dest, 0o600)'
  '';

  preBuild = ''
    cd lib/gi-crystal
    shards build -Dpreview_mt --release --no-debug
    cd ../..
    install -Dm755 lib/gi-crystal/bin/gi-crystal bin/gi-crystal
  '';

  buildTargets = [ "all" ];

  nativeBuildInputs = [
    wrapGAppsHook4
    gobject-introspection
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ desktopToDarwinBundle ];

  buildInputs = [
    webkitgtk_6_0
    sqlite
    libadwaita
    gtk4
    pango
  ];

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  doInstallCheck = false;

  passthru = {
    updateScript = _experimental-update-script-combinators.sequence [
      (gitUpdater { rev-prefix = "v"; })
      (_experimental-update-script-combinators.copyAttrOutputToFile "rtfm.shardLock" "./shard.lock")
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
          "./shard.lock"
        ];
        supportedFeatures = [ "silent" ];
      }
    ];
    shardLock = runCommand "shard.lock" { inherit src; } ''
      cp $src/shard.lock $out
    '';
  };

  meta = with lib; {
    description = "Dash/docset reader with built in documentation for Crystal and GTK APIs";
    homepage = "https://github.com/hugopl/rtfm/";
    license = licenses.mit;
    mainProgram = "rtfm";
    maintainers = with maintainers; [ sund3RRR ];
    platforms = platforms.unix;
  };
}
