{ stdenv, lib, fetchFromGitHub, rustPlatform, pkgconfig
, libsodium, libarchive, openssl }:

with rustPlatform;

buildRustPackage rec {
  name = "habitat-${version}";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "habitat-sh";
    repo = "habitat";
    rev = version;
    sha256 = "0pacxcc86w4zdakyd6qbz2rqx30rkv1j5aca1fqa1hf1jqg44vg0";
  };

  sourceRoot = "habitat-${version}-src/components/hab";

  depsSha256 = "0bm9f6w7ircji4d1c1fgysna93w0lf8ws7gfkqq80zx92x3lz5z5";

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
