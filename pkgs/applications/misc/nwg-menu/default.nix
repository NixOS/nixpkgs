{ lib, fetchFromGitHub
, buildGoModule, pkg-config, wrapGAppsHook, gobject-introspection
, gtk-layer-shell, gtk3, pango, gdk-pixbuf, atk
}:

buildGoModule rec {
  pname = "nwg-menu";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = "nwg-menu";
    rev = "v${version}";
    sha256 = "sha256-UFyC0gpKn0Ei5aOPC28iG4YI2BM5lrnl/J7RM4GjInc=";
  };

  vendorHash = "sha256-/kqhZcIuoN/XA0i1ua3lzVGn4ghkekFYScL1o3kgBX4=";

  doCheck = false;

  buildInputs = [ atk gtk3 gdk-pixbuf gtk-layer-shell pango ];
  nativeBuildInputs = [ pkg-config wrapGAppsHook gobject-introspection ];

  prePatch = ''
    for file in main.go tools.go; do
      substituteInPlace $file --replace '/usr/share/nwg-menu' $out/share
    done
  '';

  postInstall = ''
    mkdir -p $out/share/
    cp menu-start.css $out/share/
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "$out/share")
  '';

  meta = with lib; {
    homepage = "https://github.com/nwg-piotr/nwg-menu";
    description = "MenuStart plugin for nwg-panel";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ berbiche ];
  };
}
