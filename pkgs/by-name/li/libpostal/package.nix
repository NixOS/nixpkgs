{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,
  autoreconfHook,
  withData ? false,
}:

let
  releases = "https://github.com/openvenues/libpostal/releases";
  assets-base = fetchzip {
    url = "${releases}/download/v1.0.0/libpostal_data.tar.gz";
    hash = "sha256-FpGCkkRhVzyr08YcO0/iixxw0RK+3Of0sv/DH3GbbME=";
    stripRoot = false;
  };
  assets-parser = fetchzip {
    url = "${releases}/download/v1.0.0/parser.tar.gz";
    hash = "sha256-OHETb3e0GtVS2b4DgklKDlrE/8gxF7XZ3FwmCTqZbqQ=";
    stripRoot = false;
  };
  assets-language-classifier = fetchzip {
    url = "${releases}/download/v1.0.0/language_classifier.tar.gz";
    hash = "sha256-/Gn931Nx4UDBaiFUgGqC/NJUIKQ5aZT/+OYSlcfXva8=";
    stripRoot = false;
  };
in
stdenv.mkDerivation rec {
  pname = "libpostal";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "openvenues";
    repo = "libpostal";
    tag = "v${version}";
    hash = "sha256-L7t/z5mBrV7RxRrkYDRyKhjQRS1p5EOE01f2eEOUxfI=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = [
    "--disable-data-download"
  ]
  ++ lib.optionals stdenv.hostPlatform.isAarch64 [ "--disable-sse2" ];

  env = {
    NIX_CFLAGS_COMPILE = "-Wno-incompatible-pointer-types";
  };

  postBuild = lib.optionalString withData ''
    mkdir -p $out/share/libpostal
    ln -s ${assets-language-classifier}/language_classifier $out/share/libpostal/language_classifier
    ln -s ${assets-base}/transliteration                    $out/share/libpostal/transliteration
    ln -s ${assets-base}/numex                              $out/share/libpostal/numex
    ln -s ${assets-base}/address_expansions                 $out/share/libpostal/address_expansions
    ln -s ${assets-parser}/address_parser                   $out/share/libpostal/address_parser
  '';
  doCheck = withData;

  meta = with lib; {
    description = "C library for parsing/normalizing street addresses around the world. Powered by statistical NLP and open geo data";
    homepage = "https://github.com/openvenues/libpostal";
    license = licenses.mit;
    maintainers = [ maintainers.Thra11 ];
    mainProgram = "libpostal_data";
    platforms = platforms.unix;
  };
}
