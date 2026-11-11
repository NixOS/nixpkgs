{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  buildPackages,
  cargo-c,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "librice";
  # Update when https://gitlab.gnome.org/GNOME/gnome-build-meta/-/blob/gnome-50/elements/sdk/librice.bst moves to newer version.
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "ystreet";
    repo = "librice";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VBbqRBzRifXtDUuvoOEwzvkyqgWSH+pw309uQiUzQsI=";
  };

  cargoHash = "sha256-lrg21Bd+xK3xDGBjVUD+Q5m/EBIXe5po2TBsOenY8vE=";

  nativeBuildInputs = [
    cargo-c
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    openssl
  ];

  postInstall = ''
    for p in rice-proto rice-io; do
      ${buildPackages.rust.envVars.setEnv} cargo cinstall -p ''${p} -j $NIX_BUILD_CORES --release \
        --frozen --prefix=${placeholder "out"} --target ${stdenv.hostPlatform.rust.rustcTarget}
    done
  '';

  # All tests require network calls
  doCheck = false;

  meta = {
    description = "A (sans-IO) implementation of ICE (RFC8445) protocol written in Rust";
    homepage = "https://github.com/ystreet/librice";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ azban ];
  };
})
