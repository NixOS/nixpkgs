{
  lib,
  buildGoModule,
  fetchFromGitHub,
  librsvg,
  pkg-config,
  gtk3,
  gtk-layer-shell,
  wrapGAppsHook3,
}:

buildGoModule (finalAttrs: {
  pname = "nwg-bar";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = "nwg-bar";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-5N+WKZ+fuHQ0lVLd95/KkNAwzg/C4ImZ4DnSuKNGunk=";
  };

  patches = [ ./fix-paths.patch ];
  postPatch = ''
    substituteInPlace config/bar.json --subst-var out
    substituteInPlace tools.go --subst-var out
  '';

  vendorHash = "sha256-/kqhZcIuoN/XA0i1ua3lzVGn4ghkekFYScL1o3kgBX4=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    gtk-layer-shell
    librsvg
  ];

  preInstall = ''
    mkdir -p $out/share/nwg-bar
    cp -r config/* images $out/share/nwg-bar
  '';

  meta = {
    description = "GTK3-based button bar for sway and other wlroots-based compositors";
    mainProgram = "nwg-bar";
    homepage = "https://github.com/nwg-piotr/nwg-bar";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ sei40kr ];
  };
})
