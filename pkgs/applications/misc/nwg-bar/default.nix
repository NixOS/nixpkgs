{ lib
, buildGoModule
, fetchFromGitHub
, librsvg
, pkg-config
, gtk3
, gtk-layer-shell
, wrapGAppsHook }:

buildGoModule rec {
  pname = "nwg-bar";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-e64qCthZfGeFIe/g4Bu342d/C46qzJRBdxzzP6rM408=";
  };

  patches = [ ./fix-paths.patch ];
  postPatch = ''
    substituteInPlace config/bar.json --subst-var out
    substituteInPlace tools.go --subst-var out
  '';

  vendorHash = "sha256-YMpq9pgA3KjQMcw7JDwEDbHZ5h3N7ziFVIGvQ+xA3Ds=";

  nativeBuildInputs = [ pkg-config wrapGAppsHook ];

  buildInputs = [ gtk3 gtk-layer-shell librsvg ];

  preInstall = ''
    mkdir -p $out/share/nwg-bar
    cp -r config/* images $out/share/nwg-bar
  '';

  meta = with lib; {
    description =
      "GTK3-based button bar for sway and other wlroots-based compositors";
    homepage = "https://github.com/nwg-piotr/nwg-bar";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ sei40kr ];
  };
}
