{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
  testers,
  fetchzip,
  ripunzip,
}:

rustPlatform.buildRustPackage rec {
  pname = "ripunzip";
<<<<<<< HEAD
  version = "2.0.4";
=======
  version = "2.0.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "google";
    repo = "ripunzip";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-oujRw/4yKNNqLJLTN4wxaOllSUGMu077YgWZkD0DJ4M=";
  };

  cargoHash = "sha256-J6FtaWjeJhbSB1WoAbh6c4DeShPmqGgmh2NTNRS6CUk=";
=======
    hash = "sha256-giNaTALPZYOfQ+kPyQufbRTdTwwKLK7iDvg50YNfzDg=";
  };

  cargoHash = "sha256-uz07yZBkmBTEGB64rhBYQ2iL0KbrY4UAM96utv8HCSE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  buildInputs = [ openssl ];
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

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Tool to unzip files in parallel";
    mainProgram = "ripunzip";
    homepage = "https://github.com/google/ripunzip";
    license = with lib.licenses; [
      mit
      asl20
    ];
<<<<<<< HEAD
    maintainers = [ lib.maintainers.lesuisse ];
=======
    maintainers = [ maintainers.lesuisse ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
