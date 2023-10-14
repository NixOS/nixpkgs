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
  version = "0.3.9";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-RCryDei8Tw1f+7y8iIDC3mASv5nwq4qrWRc4CudS/Cg=";
  };

  vendorHash = "sha256-YwXX3srQdCicJlstodqOsL+dwBNVyJx/SwC2dMOUBh4=";

  buildInputs = [ cairo gtk3 gtk-layer-shell ];
  nativeBuildInputs = [ pkg-config wrapGAppsHook gobject-introspection ];

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
    mainProgram = "nwg-drawer";
    maintainers = with maintainers; [ plabadens ];
  };
}
