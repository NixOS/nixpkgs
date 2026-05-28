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
  # Cannot bump to 0.4.0 because it breaks webkitgtk_4_1's enableExperimental build.
  # /build/webkitgtk-2.52.1/Source/WebCore/platform/rice/GRefPtrRice.h:34:47: error: use of undeclared identifier 'rice_turn_config_ref'; did you mean 'rice_turn_config_free'?
  # 34 | WTF_DEFINE_GREF_TRAITS_INLINE(RiceTurnConfig, rice_turn_config_ref, rice_turn_config_unref)
  #    |                                               ^~~~~~~~~~~~~~~~~~~~
  #    |                                               rice_turn_config_free
  # Unpin when https://gitlab.gnome.org/GNOME/gnome-build-meta/-/blob/gnome-50/elements/sdk/librice.bst moves to newer version.
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "ystreet";
    repo = "librice";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CM+YoeVdWfnT/RjkHP0ILwMOkFEylFaN83B71r+S5Ik=";
  };

  cargoHash = "sha256-GNqzAFAnOYP5tCE4qb9F9XAlinX1xV4QyBWJjqXb5VE=";

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
