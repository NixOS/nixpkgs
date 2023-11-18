{ lib
, buildGoModule
, fetchFromGitHub
, fetchpatch
}:

buildGoModule rec {
  pname = "octorpki";
  version = "1.5.10";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "cfrpki";
    rev = "v${version}";
    hash = "sha256-eqIAauwFh1Zbv3Jkk8plz1OR3ZW8fs0ugNwwTnSHSFM=";
  };

  patches = [
    # https://github.com/cloudflare/cfrpki/pull/150
    (fetchpatch {
      url = "https://github.com/cloudflare/cfrpki/commit/fd0c4e95b880c463430c91ce1f86205b9309399b.patch";
      hash = "sha256-cJ0mWkjtGvgTIH5eEum8h2Gy2PqR+nPto+mj5m/I/d4=";
    })
  ];

  ldflags = [
    "-X main.version=v${version}"
    "-X main.talpath=${placeholder "out"}/share/tals"
  ];

  subPackages = [
    "cmd/octorpki"
  ];

  postInstall = ''
    mkdir -p $out/share
    cp -R cmd/octorpki/tals $out/share/tals
  '';

  vendorHash = null;

  meta = with lib; {
    homepage = "https://github.com/cloudflare/cfrpki#octorpki";
    changelog = "https://github.com/cloudflare/cfrpki/releases/tag/v${version}";
    description = "A software used to download RPKI (RFC 6480) certificates and validate them";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = teams.wdz.members;
  };
}
