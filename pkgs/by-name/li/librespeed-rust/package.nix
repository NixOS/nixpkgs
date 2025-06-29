{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "librespeed-rust";
  version = "unstable-2024-09-28";

  # https://github.com/librespeed/speedtest-rust/pull/7
  src = fetchFromGitHub {
    owner = "librespeed";
    repo = "speedtest-rust";
    rev = "a74f25d07da3eb665ce806e015c537264f7254c9";
    hash = "sha256-+G1DFHQONXXg/5apSBlBkRvuLT4qCJaeFnQSLWt0CD0=";
  };

  cargoHash = "sha256-4TGm7vesjeJjPxFehFZG1wICs7P0gfKcot+Cu+3Ybt8=";

  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config.toml
  '';

  postInstall = ''
    cp -r assets $out/
  '';

  meta = {
    description = "A very lightweight speed test implementation in Rust";
    homepage = "https://github.com/librespeed/speedtest-rust";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ snaki ];
    mainProgram = "librespeed-rs";
  };
}
