{
  buildGoModule,
  fetchurl,
  fetchFromGitHub,
  lib,
}:

let
  gouiJS = fetchurl {
    url = "https://storage.googleapis.com/perkeep-release/gopherjs/goui.js";
    hash = "sha256-z8A5vbkAaXCw/pv9t9sFJ2xNbEOjg4vkr/YBkNptc3U=";
  };

  publisherJS = fetchurl {
    url = "https://storage.googleapis.com/perkeep-release/gopherjs/publisher.js";
    hash = "sha256-4iKMkOEKPCo6Xrq0L5IglVZpB9wyLymCgRYz3cE9DSY=";
  };

  packages = [
    "perkeep.org/server/perkeepd"
    "perkeep.org/cmd/pk"
    "perkeep.org/cmd/pk-get"
    "perkeep.org/cmd/pk-put"
    "perkeep.org/cmd/pk-mount"
  ];

in
buildGoModule rec {
  pname = "perkeep";
  version = "0.11";

  src = fetchFromGitHub {
    owner = "perkeep";
    repo = "perkeep";
    rev = version;
    hash = "sha256-lGZb9tH1MrclCRkkmNB85dP/Hl+kkue/WplNMul9RR4=";
  };

  vendorHash = "sha256-y+AYUG15tsj5SppY2bTg/dh3LPpp+14smCo7nLJRyak=";
  deleteVendor = true; # Vendor is out of sync with go.mod

  buildPhase = ''
    cd "$NIX_BUILD_TOP/source"

    # Skip network fetches
    cp ${publisherJS} app/publisher/publisher.js
    cp ${gouiJS} server/perkeepd/ui/goui.js

    go run make.go -offline=true -targets=${lib.concatStringsSep "," packages}
  '';

  # genfileembed gets built regardless of -targets, to embed static
  # content into the Perkeep binaries. Remove it in post-install to
  # avoid polluting paths.
  postInstall = ''
    rm -f $out/bin/genfileembed
  '';

  meta = with lib; {
    description = "Way of storing, syncing, sharing, modelling and backing up content (née Camlistore)";
    homepage = "https://perkeep.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit ];
  };
}
