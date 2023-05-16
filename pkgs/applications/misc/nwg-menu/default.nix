{ lib, fetchFromGitHub
, buildGoModule, pkg-config, wrapGAppsHook, gobject-introspection
, gtk-layer-shell, gtk3, pango, gdk-pixbuf, atk
}:

buildGoModule rec {
  pname = "nwg-menu";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = "nwg-menu";
    rev = "v${version}";
    sha256 = "sha256-M948RGU9/PwUtFRmf1Po7KlrGxqRPiOZKfS1Vv3vqW8=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-HyrjquJ91ddkyS8JijHd9HjtfwSQykXCufa2wzl8RNk=";
=======
  vendorSha256 = "sha256-HyrjquJ91ddkyS8JijHd9HjtfwSQykXCufa2wzl8RNk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
