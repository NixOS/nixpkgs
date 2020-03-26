{ pkgs
, fetchFromGitHub
, stdenv
, rustPlatform
, atk
, gnome2
, cairo
, glib
, gdk_pixbuf
, gtkd
, gtk3
, wrapGAppsHook
}:
rustPlatform.buildRustPackage rec {
  name = "fitnesstrax";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "luminescent-dreams";
    repo = "fitnesstrax";
    rev = "0.1.0";
    sha256 = "1k6zhnbs0ggx7q0ig2abcnzprsgrychlpvsh6d36dw6mr8zpfkp7";
  };

  buildInputs = [
    atk
    gnome2.pango
    cairo
    glib
    gdk_pixbuf
    gtkd
    gtk3
  ];

  nativeBuildInputs = [ wrapGAppsHook ];

  cargoSha256 = "0p0d72njx5m2v6x94sxc2ldjipl4j3cw876shbdq7ghkjjkxv93m";

  postInstall = ''
    mkdir -p $out/share/glib-2.0/schemas
    cp -r $src/share/* $out/share/
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  meta = with stdenv.lib; {
    description = "Privacy-first fitness tracking";
    homepage = "https://github.com/luminescent-dreams/fitnesstrax";
    license = licenses.bsd3;
    maintainers = [ "savanni@luminescent-dreams.com" ];
  };
}
