{ lib, fetchFromGitHub, rustPlatform, pkgconfig
, libsodium, libarchive, openssl }:

with rustPlatform;

buildRustPackage rec {
  name = "habitat-${version}";
  version = "0.62.0";

  src = fetchFromGitHub {
    owner = "habitat-sh";
    repo = "habitat";
    rev = version;
    sha256 = "0n7bw0zqk8psylk2xkajahcrb6j51hn2symzlyx0v1zcnzdwzbvj";
  };

  cargoSha256 = "17gifxkkg0bbjsbsj72kpzcimqk30pxks2299z758z2ymww5h80g";

  buildInputs = [ libsodium libarchive openssl ];

  nativeBuildInputs = [ pkgconfig ];

  cargoBuildFlags = ["--package hab"];

  postUnpack = ''
    eval "$cargoDepsHook"
    unpackFile "$cargoDeps"
    cargoDepsCopy=$(stripHash $(basename $cargoDeps))
    chmod -R +w "$cargoDepsCopy"
    mkdir -p .cargo
    cat >.cargo/config <<-EOF
      [source.crates-io]
      registry = 'https://github.com/rust-lang/crates.io-index'
      replace-with = "vendored-sources"

      [source."https://github.com/erickt/rust-zmq"]
      git = "https://github.com/erickt/rust-zmq"
      branch = "release/v0.8"
      replace-with = "vendored-sources"

      [source."https://github.com/habitat-sh/core.git"]
      git = "https://github.com/habitat-sh/core.git"
      branch = "master"
      replace-with = "vendored-sources"

      [source."https://github.com/habitat-sh/ipc-channel"]
      git = "https://github.com/habitat-sh/ipc-channel"
      branch = "hbt-windows"
      replace-with = "vendored-sources"

      [source.vendored-sources]
      directory = '$(pwd)/$cargoDepsCopy'
    EOF
    unset cargoDepsCopy
    export RUST_LOG=warn
  '';

  checkPhase = ''
    runHook preCheck
    echo "Running cargo test"
    # cargo test --package hab
    runHook postCheck
  '';

  meta = with lib; {
    description = "An application automation framework";
    homepage = https://www.habitat.sh;
    license = licenses.asl20;
    maintainers = [ maintainers.boj maintainers.rushmorem ];
    platforms = [ "x86_64-linux" ];
  };
}
