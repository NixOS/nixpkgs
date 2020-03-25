{ pkgs,
  fetchFromGitHub ? pkgs.fetchFromGitHub,
  stdenv ? pkgs.stdenv,
  rustPlatform ? pkgs.rustPlatform,
  wrapGAppsHook ? pkgs.wrapGAppsHook,
}:
rustPlatform.buildRustPackage rec {
  name = "fitnesstrax-${version}";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "luminescent-dreams";
    repo = "fitnesstrax";
    rev = "516a9e48978ac0f90bbbeade34d626211ccb78a3";
    sha256 = "1k6zhnbs0ggx7q0ig2abcnzprsgrychlpvsh6d36dw6mr8zpfkp7";
  };

  nativeBuildInputs = [
    pkgs.glib
    pkgs.atk
    pkgs.gnome2.pango
    pkgs.cairo
    pkgs.glib
    pkgs.gdk_pixbuf
    pkgs.gtkd
    pkgs.gtk3
    wrapGAppsHook
    ];

  cargoSha256 = "0p0d72njx5m2v6x94sxc2ldjipl4j3cw876shbdq7ghkjjkxv93m";

  postInstall = ''
    mkdir -p $out/share/glib-2.0/schemas
    cp -r $src/share/* $out/share/
    glib-compile-schemas $out/share/glib-2.0/schemas
    '';

  meta = with stdenv.lib; {
    description = "Privacy-first fitness tracking. Your health, your data, your machine.";
    homepage = "https://github.com/luminescent-dreams/fitnesstrax";
    license = licenses.bsd3;
    maintainers = [ "savanni@luminescent-dreams.com" ];
  };
}
