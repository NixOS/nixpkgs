{ buildGoPackage, fetchurl, fetchFromGitHub, lib }:

let
  gouiJS = fetchurl {
    url = "https://storage.googleapis.com/perkeep-release/gopherjs/goui.js";
    sha256 = "0xbkdpd900gnmzj8p0x38dn4sv170pdvgzcvzsq70s80p6ykkh6g";
  };

  publisherJS = fetchurl {
    url = "https://storage.googleapis.com/perkeep-release/gopherjs/publisher.js";
    sha256 = "09hd7p0xscqnh612jbrjvh3njmlm4292zd5sbqx2lg0aw688q8p2";
  };

in buildGoPackage rec {
  name = "perkeep-${version}";
  version = "unstable-2019-07-29";

  src = fetchFromGitHub {
    owner = "perkeep";
    repo = "perkeep";
    rev = "c9f78d02adf9740f3b8d403a1418554293cc9f41";
    sha256 = "11rin94pjzg0kvizrq9ss42fjw7wfwx3g1pk8zdlhyfkiwwh2rmg";
  };

  goPackagePath = "perkeep.org";

  buildPhase = ''
    cd "$NIX_BUILD_TOP/go/src/$goPackagePath"

    # Skip network fetches
    sed -i '/fetchAllJS/a if true { return nil }' make.go
    cp ${publisherJS} app/publisher/publisher.js
    cp ${gouiJS} server/perkeepd/ui/goui.js

    go run make.go
  '';

  # devcam is only useful when developing perkeep, we should not install it as
  # part of this derivation.
  postInstall = ''
    rm -f $out/bin/devcam
  '';

  meta = with lib; {
    description = "A way of storing, syncing, sharing, modelling and backing up content (née Camlistore)";
    homepage = https://perkeep.org;
    license = licenses.asl20;
    maintainers = with maintainers; [ cstrahan kalbasit ];
    platforms = platforms.unix;
  };
}
