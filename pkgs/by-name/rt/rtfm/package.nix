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
  pango,
  substituteAll,
}:
let
  gtk4' = gtk4.override { x11Support = true; };
  pango' = pango.override { withIntrospection = true; };
in
crystal.buildCrystalPackage rec {
  pname = "rtfm";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "hugopl";
    repo = "rtfm";
    rev = "v${version}";
    name = "rtfm";
    hash = "sha256-+s7KXl3+j/BaneOBqVAMJJhmrG6xtcGaHhYnMvUfiVA=";
  };

  patches = [
    # 1) fixed gi-crystal binding generator command
    # 2) fixed docset generator command
    # 3) added commands to build gschemas and update icon-cache
    (substituteAll {
      src = ./make.patch;
      inherit crystal;
    })
    # added chmod +w for copied docs to prevent error:
    # `Error opening file with mode 'wb': '.../style.css': Permission denied`
    ./enable-write-permissions.patch
  ];

  postPatch = ''
    substituteInPlace src/doc2dash/create_gtk_docset.cr \
      --replace-fail 'basedir = Path.new("/usr/share/doc")' 'basedir = Path.new(ARGV[0]? || "gtk-docs")'
  '';

  shardsFile = ./shards.nix;
  copyShardDeps = true;

  nativeBuildInputs = [
    wrapGAppsHook4
    gobject-introspection
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ desktopToDarwinBundle ];

  buildInputs = [
    webkitgtk_6_0
    sqlite
    libadwaita
    gtk4'
    pango'
  ];

  buildTargets = [
    "configure"
    "rtfm"
    "docsets"
  ];

  preBuild = ''
    mkdir gtk-doc/

    for file in "${gtk4'.devdoc}"/share/doc/*; do
      ln -s "$file" "gtk-doc/$(basename "$file")"
    done

    for file in "${pango'.devdoc}"/share/doc/*; do
      ln -s "$file" "gtk-doc/$(basename "$file")"
    done

    for file in "${libadwaita.devdoc}"/share/doc/*; do
      ln -s "$file" "gtk-doc/$(basename "$file")"
    done
  '';

  meta = with lib; {
    description = "Dash/docset reader with built in documentation for Crystal and GTK APIs";
    homepage = "https://github.com/hugopl/rtfm/";
    license = licenses.mit;
    mainProgram = "rtfm";
    maintainers = with maintainers; [ sund3RRR ];
  };
}
