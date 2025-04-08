{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  pkg-config,
  doxygen,
  check,
  jansson,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "cjose";
  version = "0.6.2.2";

  src = fetchFromGitHub {
    owner = "zmartzone";
    repo = "cjose";
    rev = "v${version}";
    sha256 = "sha256-vDvCxMpgCdteGvNxy2HCNRaxbhxOuTadL0nM2wkFHtk=";
  };

  patches = [
    # avoid using empty prototypes; support Clang 15 and XCode 14.3 - https://github.com/OpenIDC/cjose/pull/19
    (fetchpatch {
      url = "https://github.com/OpenIDC/cjose/commit/63e90cf464d6a470e26886435e8d7d96a66747f6.patch";
      hash = "sha256-+C5AIejb9InOGiOgUNfuP89J18O71rnq1pXyroxEDFQ=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    doxygen
  ];
  buildInputs = [
    jansson
    openssl
  ];
  nativeCheckInputs = [ check ];

  configureFlags = [
    "--with-jansson=${jansson}"
    "--with-openssl=${openssl.dev}"
  ];

  meta = with lib; {
    homepage = "https://github.com/zmartzone/cjose";
    changelog = "https://github.com/zmartzone/cjose/blob/${version}/CHANGELOG.md";
    description = "C library for Javascript Object Signing and Encryption. This is a maintained fork of the original project";
    license = licenses.mit;
    maintainers = with maintainers; [ midchildan ];
    platforms = platforms.all;
  };
}
