{ stdenv, lib, fetchFromGitHub, rustPlatform, pkgconfig
, libsodium, libarchive, openssl }:

with rustPlatform;

buildRustPackage rec {
  name = "habitat-${version}";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "habitat-sh";
    repo = "habitat";
    rev = version;
    sha256 = "1h9wv2v4hcv79jkkjf8j96lzxni9d51755zfflfr5s3ayaip7rzj";
  };

  sourceRoot = "habitat-${version}-src/components/hab";

  depsSha256 = "1612jaw3zdrgrb56r755bb18l8szdmf1wi7p9lpv3d2gklqcb7l1";

  buildInputs = [ libsodium libarchive openssl ];

  nativeBuildInputs = [ pkgconfig ];

  meta = with lib; {
    description = "An application automation framework";
    homepage = https://www.habitat.sh;
    license = licenses.asl20;
    maintainers = [ maintainers.rushmorem ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
