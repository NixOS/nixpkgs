{ stdenv, lib, fetchFromGitHub, rustPlatform, pkgconfig
, libsodium, libarchive, openssl }:

with rustPlatform;

buildRustPackage rec {
  name = "habitat-${version}";
  version = "0.30.2";

  src = fetchFromGitHub {
    owner = "habitat-sh";
    repo = "habitat";
    rev = version;
    sha256 = "0pqrm85pd9hqn5fwqjbyyrrfh4k7q9mi9qy9hm8yigk5l8mw44y1";
  };

  cargoSha256 = "1ahfm5agvabqqqgjsyjb95xxbc7mng1mdyclcakwp1m1qdkxx9p0";

  buildInputs = [ libsodium libarchive openssl ];

  nativeBuildInputs = [ pkgconfig ];

  cargoBuildFlags = ["--package hab"];

  checkPhase = ''
    runHook preCheck
    echo "Running cargo test"
    cargo test --package hab
    runHook postCheck
  '';

  meta = with lib; {
    description = "An application automation framework";
    homepage = https://www.habitat.sh;
    license = licenses.asl20;
    maintainers = [ maintainers.rushmorem ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    broken = true; # mark temporary as broken due git dependencies
  };
}
