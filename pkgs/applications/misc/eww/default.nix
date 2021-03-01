{ lib, stdenv, callPackage, fetchFromGitHub, pkgconfig, rustPlatform, glib
, cairo, pango, atk, gdk_pixbuf, gtk3-x11 }:

let
  mkRustPlatform = callPackage ./nightly-rust-platform.nix { };
  rustPlatform = mkRustPlatform {
    date = "2020-10-28";
    channel = "nightly";
  };
in rustPlatform.buildRustPackage rec {
  pname = "eww";
  version = "unstable-2021-02-26";

  src = fetchFromGitHub {
    owner = "elkowar";
    repo = "eww";
    rev = "a18901f187ff850a21a24c0c59022c0a5382ffd9";
    sha256 = "1sy3fzb64f242mfx2xy0ip9n4iqwab0w0ihfs2n9hpvxajzxfwc8";
  };

  cargoSha256 = "19ad9p40yacwlcmzvxdcdrfk01jdswkgncyb7hhvbv9c790m9slw";
  verifyCargoDeps = true;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib pango cairo atk gdk_pixbuf gtk3-x11 ];

  # For the files Cargo nightly will put in $HOME
  preConfigure = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    homepage = "https://elkowar.github.io/eww/main/";
    description = "ElKowar's widgeting system written in Rust";
    longDescription = ''
      Eww (ElKowar's Wacky Widgets, pronounced with sufficient amounts of disgust) is a widgeting system made in Rust, which lets you create your own widgets similarly to how you can in AwesomeWM. The key difference: it is independent of your window manager!

      Configured in XML and themed using CSS, it is easy to customize and provides all the flexibility you need!
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ wunderbrick ];
    platforms = platforms.unix;
  };
}
