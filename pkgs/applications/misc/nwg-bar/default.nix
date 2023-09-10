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
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/GkusNhHprXwGMNDruEEuFC2ULVIHBN5F00GNex/uq4=";
  };

  patches = [ ./fix-paths.patch ];
  postPatch = ''
    substituteInPlace config/bar.json --subst-var out
    substituteInPlace tools.go --subst-var out
  '';

  vendorHash = "sha256-mqcXhnja8ed7vXIqOKBsNrcbrcaycTQXG1jqdc6zcyI=";

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
