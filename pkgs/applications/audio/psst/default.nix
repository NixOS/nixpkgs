{ lib, rustPlatform, fetchFromGitHub, pkg-config, gtk3, glib,
gdk-pixbuf, cairo , pango, dbus, stdenv, darwin ? null }:

rustPlatform.buildRustPackage rec {
  pname = "psst";
  version = "unstable-2021-08-19";

  src = fetchFromGitHub {
    owner = "jpochyla";
    repo = pname;
    rev = "724aa251407dfa93b8ede8e879fd5ca35de1ddd2";
    sha256 = "08m6h2gkgnpmfpw93zb6rhrvbw5rhq0mgpcfzingdvsqw531r13w";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk3 glib gdk-pixbuf cairo pango dbus ]
  ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    AppKit CoreFoundation CoreGraphics CoreText CoreVideo
    Foundation MediaPlayer QuartzCore Security ]);

  cargoSha256 = "19xfpmlfpq6ba0i4pissxlngdqg5ydnpa7izg8hky2ryyf48kvf7";

  meta = with lib; {
    description = "Fast and multi-platform Spotify client with native GUI";
    homepage = "https://github.com/jpochyla/psst";
    license = licenses.mit;
    maintainers = with maintainers; [ mth ];
  };
}
