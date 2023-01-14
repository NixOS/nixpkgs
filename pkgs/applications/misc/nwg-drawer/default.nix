{ lib
, buildGoModule
, fetchFromGitHub
, cairo
, gobject-introspection
, gtk3
, gtk-layer-shell
, pkg-config
, wrapGAppsHook
, xdg-utils }:

buildGoModule rec {
  pname = "nwg-drawer";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-OcOF43SOlseb6UGTxLtGH0MRokZob0x+cczpdJc8Hq4=";
  };

  vendorHash = "sha256-RehZ86XuFs1kbm9V3cgPz1SPG3izK7/6fHQjPTHOYZs=";

  buildInputs = [ cairo gobject-introspection gtk3 gtk-layer-shell ];
  nativeBuildInputs = [ pkg-config wrapGAppsHook ];

  doCheck = false;

  preInstall = ''
    mkdir -p $out/share/nwg-drawer
    cp -r desktop-directories drawer.css $out/share/nwg-drawer
  '';

  preFixup = ''
    # make xdg-open overrideable at runtime
    gappsWrapperArgs+=(
      --suffix PATH : ${xdg-utils}/bin
      --prefix XDG_DATA_DIRS : $out/share
    )
  '';

  meta = with lib; {
    description = "Application drawer for sway Wayland compositor";
    homepage = "https://github.com/nwg-piotr/nwg-drawer";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ plabadens ];
  };
}
