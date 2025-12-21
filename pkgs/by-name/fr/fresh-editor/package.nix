{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchurl,
  pkg-config,
  openssl,
  gzip,
  git,
  makeBinaryWrapper,
  writableTmpDirAsHomeHook,
}:

let
  # Pre-fetch the V8 binary that rusty_v8 wants to download
  rusty_v8_archive = fetchurl {
    url = "https://github.com/denoland/rusty_v8/releases/download/v142.2.0/librusty_v8_release_x86_64-unknown-linux-gnu.a.gz";
    hash = "sha256-xHmofo8wTNg88/TuC2pX2OHDRYtHncoSvSBnTV65o+0=";
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fresh";
  version = "0.1.56";

  src = fetchFromGitHub {
    owner = "sinelaw";
    repo = "fresh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-prgTX6nPWqVqvQkxkWrMLF5pB6vSJ+TKzM41coC5otk=";
  };

  cargoHash = "sha256-efGrh4ToPypQoPZ3sSj62UcJTFFirAfraZkKI1CH5Tw=";

  nativeBuildInputs = [
    pkg-config
    gzip
    writableTmpDirAsHomeHook
  ];

  nativeCheckInputs = [
    git
  ];

  buildInputs = [
    openssl
  ];

  # Due to issues with incorrect import paths with the actual app, I have disabled the checks below. Need to report upstream.
  checkFlags = [
    "--skip=e2e::"
  ];
  cargoTestFlags = [
    "--lib"
    "--bins"
  ];

  # Provide the pre-downloaded V8 binary to the build
  preBuild = ''
    mkdir -p $HOME/.cargo/.rusty_v8
    mkdir -p $out/share/fresh-editor/plugins/examples
    cp ${rusty_v8_archive} $HOME/.cargo/.rusty_v8/https___github_com_denoland_rusty_v8_releases_download_v142_2_0_librusty_v8_release_x86_64_unknown_linux_gnu_a_gz
  '';

  meta = {
    description = "Terminal-based text editor with LSP support and TypeScript plugins";
    homepage = "https://github.com/sinelaw/fresh";
    changelog = "https://github.com/sinelaw/fresh/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ randoneering ];
    mainProgram = "fresh";
    platforms = lib.platforms.linux;
  };
})
