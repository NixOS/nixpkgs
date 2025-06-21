{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "protonup-rs";
  version = "0.9.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-OVdoXe83lH6wjYb36tT4P3sG1w6NdWhRYC0L3v8USs4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-qESp4z3HRe414Ro04NuiVNy0j/zJUmII4Gbacs3Bc48=";

  checkFlags = [
    # Requires internet access
    "--skip=downloads::tests"
  ];

  meta = {
    description = "Rust app to install and update GE-Proton for Steam, and Wine-GE for Lutris";
    homepage = "https://github.com/auyer/Protonup-rs";
    changelog = "https://github.com/auyer/Protonup-rs/releases/tag/v${finalAttrs.version}";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      joshprk
    ];
    mainProgram = "protonup-rs";
  };
})
