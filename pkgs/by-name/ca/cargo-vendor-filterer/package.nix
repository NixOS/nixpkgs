{
  pkgs,
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-vendor-filterer";
  version = "0.5.17";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-iqeo/swZg2TnOnMJMXYWu2uC6EG3FBQURIbg9ajYvvo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Mip5gYHljXczeOnz9VgqXcnyXsfF5F33Adi0ur5om3U=";

  nativeBuildInputs = with pkgs; [
    pkg-config
  ];

  buildInputs = with pkgs; [
    openssl
  ];

  cargoTestFlags = [ "--no-fail-fast" ];

  checkFlags = [
    "--skip=vendor_filterer::basic::default_output_folder"
    "--skip=vendor_filterer::exclude::linux_multiple_platforms"
    "--skip=vendor_filterer::exclude::windows_with_dep_kind_filter_normal"
    "--skip=vendor_filterer::format::folder"
    "--skip=vendor_filterer::format::tar"
    "--skip=vendor_filterer::format::tar_gz"
    "--skip=vendor_filterer::format::tar_zstd"
    "--skip=vendor_filterer::platform::linux"
    "--skip=vendor_filterer::platform::linux_glob"
    "--skip=vendor_filterer::platform::linux_multiple"
    "--skip=vendor_filterer::sync::basic_sync"
    "--skip=vendor_filterer::sync::filter_without_manifest_but_sync"
    "--skip=vendor_filterer::sync::filter_without_manifest_path"
    "--skip=vendor_filterer::sync::multiple_syncs"
    "--skip=vendor_filterer::sync::sync_platform_with_exclude"
    "--skip=vendor_filterer::sync::sync_with_platform_filter"
    "--skip=vendor_filterer::toml::manifest_path"
    "--skip=vendor_filterer::toml::metadata"
    "--skip=vendor_filterer::versioned_dirs::multiple_versions"
    "--skip=vendor_filterer::versioned_dirs::multiple_versions_without_flag"
    "--skip=vendor_filterer::versioned_dirs::only_one_version"
  ];

  meta = with lib; {
    description = "Cargo subcommand like cargo vendor, but with filtering";
    mainProgram = "cargo-vendor-filterer";
    homepage = "https://github.com/coreos/cargo-vendor-filterer";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [
      gauravjuvekar
    ];
  };
}
