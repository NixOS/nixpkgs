{
  fetchFromGitHub,
  lib,
  openssl,
  pkg-config,
  rustPlatform,
  ...
}:
rustPlatform.buildRustPackage (
  let
    inherit (lib) licenses maintainers platforms;
    name = "dness";
    version = "v0.5.7";
    src = fetchFromGitHub {
      owner = "nickbabcock";
      repo = "dness";
      rev = version;
      hash = "sha256-Vty4ec6aoUh3p2b9vLkNeS5R4pJWzjwYrC5DtVVyhT8=";
    };
  in
  {
    pname = name;
    inherit src version;
    nativeBuildInputs = [
      pkg-config
    ];
    PKG_CONFIG_PATH = "${openssl.dev}/lib/pkgconfig";
    cargoHash = "sha256-VyjntXsb1FUNguJFEmaZmjeCUHPMHMDICTTMDwExNBI=";
    checkFlags = [
      # The following tests require network access.
      "--skip=dns::tests::cloudflare_test"
      "--skip=dns::tests::opendns_lookup_ip_test"
      "--skip=dynu::tests::test_dynu_update"
      "--skip=he::tests::test_he_update"
      "--skip=namecheap::tests::test_namecheap_update"
      "--skip=noip::tests::test_noip_update"
    ];
    meta = {
      description = "A dynamic DNS updating tool supporting a variety of providers.";
      homepage = "https://github.com/nickbabcock/dness";
      maintainers = with maintainers; [ logan-barnett ];
      platforms = platforms.unix;
      license = licenses.mit;
    };
  }
)
