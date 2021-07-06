{ lib, fetchFromGitHub
, buildGoModule, pkg-config, wrapGAppsHook, gobject-introspection
, gtk-layer-shell, gtk3, pango, gdk-pixbuf, atk
}:

buildGoModule rec {
  pname = "nwg-menu";
  version = "unstable-2021-06-12";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = "nwg-menu";
    rev = "b0746e26514a047ed9c6b975a71b7263aa39bd56";
    hash = "sha256-rxyf3CfpfWnRAlIR/pl+s7LGAZbZjdtNWPPK7BecdhQ=";
  };

  vendorSha256 = "sha256-nN5iBleK12SKY9PBiDA+tM4B8FiVGZLXbtJM2+YrEfA=";

  runVend = true;

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
