{
  lib,
  rustPlatform,
  fetchCrate,
}:
rustPlatform.buildRustPackage rec {
  pname = "stylance-cli";
  version = "0.5.4";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-Xh0xqD0B4uKu5uoEWNe0pf+ExhaqPBgsR1OEfKe0TvA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-fGU+aKXBef7ZoNESTHf8JdDIDJuTaSklkr+DyehpHgA=";

  meta = with lib; {
    description = "Library and cli tool for working with scoped CSS in rust";
    mainProgram = "stylance";
    homepage = "https://github.com/basro/stylance-rs";
    changelog = "https://github.com/basro/stylance-rs/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ dav-wolff ];
  };
}
