{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  darwin,
  pkg-config,
  testers,
  fetchzip,
  ripunzip,
}:

rustPlatform.buildRustPackage rec {
  pname = "ripunzip";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "ripunzip";
    rev = "v${version}";
    hash = "sha256-Y4p3CFE8MyEQJ/af0g2/EL4kto/VZABvD5OS0rRuo8g=";
  };

  cargoHash = "sha256-5KHF5x4papscMFeXbFYQ+Qyso5YtMoIOO+cq8Omrbs8=";

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        Security
        SystemConfiguration
      ]
    );
  nativeBuildInputs = [ pkg-config ];

  checkFlags = [
    # Skip tests involving network
    "--skip=unzip::http_range_reader::tests::test_with_accept_range"
    "--skip=unzip::http_range_reader::tests::test_without_accept_range"
    "--skip=unzip::seekable_http_reader::tests::test_big_readahead"
    "--skip=unzip::seekable_http_reader::tests::test_random_access"
    "--skip=unzip::seekable_http_reader::tests::test_small_readahead"
    "--skip=unzip::seekable_http_reader::tests::test_unlimited_readahead"
    "--skip=unzip::tests::test_extract_biggish_zip_from_ranges_server"
    "--skip=unzip::tests::test_extract_from_server"
    "--skip=unzip::tests::test_small_zip_from_no_content_length_server"
    "--skip=unzip::tests::test_small_zip_from_no_range_server"
    "--skip=unzip::tests::test_small_zip_from_ranges_server"
  ];

  setupHook = ./setup-hook.sh;

  passthru.tests = {
    fetchzipWithRipunzip =
      testers.invalidateFetcherByDrvHash (fetchzip.override { unzip = ripunzip; })
        {
          url = "https://github.com/google/ripunzip/archive/cb9caa3ba4b0e27a85e165be64c40f1f6dfcc085.zip";
          hash = "sha256-BoErC5VL3Vpvkx6xJq6J+eUJrBnjVEdTuSo7zh98Jy4=";
        };
    version = testers.testVersion {
      package = ripunzip;
    };
  };

  meta = with lib; {
    description = "Tool to unzip files in parallel";
    mainProgram = "ripunzip";
    homepage = "https://github.com/google/ripunzip";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = [ maintainers.lesuisse ];
  };
}
