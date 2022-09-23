{ buildGoModule, fetchurl, fetchFromGitHub, lib }:

let
  gouiJS = fetchurl {
    url = "https://storage.googleapis.com/perkeep-release/gopherjs/goui.js";
    sha256 = "0xbkdpd900gnmzj8p0x38dn4sv170pdvgzcvzsq70s80p6ykkh6g";
  };

  publisherJS = fetchurl {
    url = "https://storage.googleapis.com/perkeep-release/gopherjs/publisher.js";
    sha256 = "09hd7p0xscqnh612jbrjvh3njmlm4292zd5sbqx2lg0aw688q8p2";
  };

  packages = [
    "perkeep.org/server/perkeepd"
    "perkeep.org/cmd/pk"
    "perkeep.org/cmd/pk-get"
    "perkeep.org/cmd/pk-put"
    "perkeep.org/cmd/pk-mount"
  ];

in buildGoModule rec {
  pname = "perkeep";
  version = "0.11";

  src = fetchFromGitHub {
    owner = "perkeep";
    repo = "perkeep";
    rev = version;
    sha256 = "07j5gplk4kcrbazyg4m4bwggzlz5gk89h90r14jvfcpms7v5nrll";
  };

  vendorSha256 = "1af9a6r9qfrak0n5xyv9z8n7gn7xw2sdjn4s9bwwidkrdm81iq6b";
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
    description = "A way of storing, syncing, sharing, modelling and backing up content (née Camlistore)";
    homepage = "https://perkeep.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ cstrahan danderson kalbasit ];
  };
}
