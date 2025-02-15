{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nasm,
  pkg-config,
  meson,
  ninja,
}:

rustPlatform.buildRustPackage rec {
  pname = "rav1d";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "memorysafety";
    repo = "rav1d";
    tag = "v${version}";
    hash = "sha256-8Moj3v7cxPluzNPmOmGhYuz/Qh48BnBjN7Vt4f8aY2o=";
  };

  cargoHash = "sha256-nfZhcg/wDFUBSrNWt39bZWriHH0VIn99uxSsbhWH6Uk=";

  nativeBuildInputs = [
    pkg-config
    nasm
    meson
    ninja
  ];

  doCheck = false;

  preConfigure = ''
    mkdir -p build
  '';

  configurePhase = ''
    meson build --prefix=$out
  '';

  buildPhase = ''
    ninja -C build
    cargo build --release
  '';

  installPhase = ''
    DESTDIR=$out ninja -C build install

    mkdir -p $out/lib
    cp target/release/librav1d.a $out/lib/
  '';

  meta = {
    description = "AV1 cross-platform decoder, Rust port of dav1d";
    homepage = "https://github.com/memorysafety/rav1d";
    changelog = "https://github.com/memorysafety/rav1d/releases/tag/v${version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ liberodark ];
  };
}
