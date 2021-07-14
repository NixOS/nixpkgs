{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "lightwalletd";
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "zcash";
    repo  = "lightwalletd";
    rev = "v${version}";
    sha256 = "0dwam3fhc4caga7kjg6cc06sz47g4ii7n3sa4j2ac4aiy21hsbjk";
  };

  vendorSha256 = null;

  ldflags = [
    "-s" "-w"
    "-X github.com/zcash/lightwalletd/common.Version=v${version}"
    "-X github.com/zcash/lightwalletd/common.GitCommit=v${version}"
    "-X github.com/zcash/lightwalletd/common.BuildDate=1970-01-01"
    "-X github.com/zcash/lightwalletd/common.BuildUser=nixbld"
  ];

  postFixup = ''
    shopt -s extglob
    cd $out/bin
    rm !(lightwalletd)
  '';

  meta = with lib; {
    description = "A backend service that provides a bandwidth-efficient interface to the Zcash blockchain";
    homepage = "https://github.com/zcash/lightwalletd";
    maintainers = with maintainers; [ centromere ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
