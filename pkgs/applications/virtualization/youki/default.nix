{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, dbus
, libseccomp
, systemd
}:

rustPlatform.buildRustPackage rec {
  pname = "youki";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-iO7vX0xJRZB4c3Tvvx9IWs+oEJQ90mQarJ43EttFYzY=";
  };

  cargoSha256 = "sha256-oygT0DMDKaJEVeVkEY12T99qgvc0G/z0ZSNWabqOu50=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ dbus libseccomp systemd ];

  preBuild = ''
    rm .cargo/config

    substituteInPlace crates/youki/Cargo.toml \
      --replace 'build = "build.rs"' ""

    rm crates/youki/build.rs

    export \
      VERGEN_BUILD_SEMVER="${version}" \
      VERGEN_BUILD_TIMESTAMP="$SOURCE_DATE_EPOCH" \
      VERGEN_GIT_SHA_SHORT="${src.rev}" \
      VERGEN_GIT_SHA="${src.rev}" \
      VERGEN_RUSTC_HOST_TRIPLE=""
  '';

  doCheck = false; # timeout

  meta = with lib; {
    description = "Container runtime written in Rust";
    homepage = "https://github.com/containers/youki";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
