{ stdenv, fetchFromGitHub, makeWrapper, callPackage, libgroove, python, utillinux, nodejs }:

with stdenv.lib;

let
  nodePackages = callPackage (import ../../../top-level/node-packages.nix) {
    inherit nodejs;
    neededNatives = [ libgroove python utillinux ];
    self = nodePackages;
    generated = ./package.nix;
  };

in nodePackages.buildNodePackage rec {
  version = "1.5.1";
  name = "groovebasin-${version}";

  src = fetchFromGitHub {
    owner = "andrewrk";
    repo = "groovebasin";
    rev = "${version}";
    sha256 = "1g7v0qhvgzpb050hf45pibp68qd67hnnry5npw58f4dvaxdd8yhd";
  };

  deps = (filter (v: nixType v == "derivation") (attrValues nodePackages));

  buildInputs = [ makeWrapper ];

  postInstall = ''
    mkdir -p "$out/lib/node_modules/groovebasin/public"
    stylus -o "$out/lib/node_modules/groovebasin/public/" -c --include-css "$out/lib/node_modules/groovebasin/src/client/styles"
    browserify-lite "$out/lib/node_modules/groovebasin/src/client/app.js" --outfile "$out/lib/node_modules/groovebasin/public/app.js"
    wrapProgram "$out/bin/groovebasin" --set NODE_PATH "$out/lib/node_modules/groovebasin/node_modules/"
  '';

  passthru.names = ["groovebasin"];

  meta = {
    description = "Music player server with a web-based user interface";
    homepage = http://groovebasin.com/;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.andrewrk ];
    longDescription = ''
      Groove Basin runs on a server optionally connected to speakers. Guests can
      control the music player by connecting with a laptop, tablet, or smart phone.
      Further, users can stream their music libraries remotely.

      Groove Basin comes with a fast, responsive web interface that supports keyboard
      shortcuts and drag drop. It also provides the ability to upload songs,
      download songs, and import songs by URL, including YouTube URLs.

      Groove Basin supports Dynamic Mode which automatically queues random songs,
      favoring songs that have not been queued recently.

      Groove Basin automatically performs ReplayGain scanning on every song using
      the EBU R128 loudness standard, and automatically switches between track
      and album mode.

      Groove Basin supports the MPD protocol, which means it is compatible with MPD
      clients. There is also a more powerful Groove Basin protocol which you can
      use if the MPD protocol does not meet your needs.

      Groove Basin supports Last.fm scrobbling.
    '';
  };
}
