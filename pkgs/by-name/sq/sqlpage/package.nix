{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  sqlite,
  zstd,
  fetchurl,
}:

let
  apexcharts = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/apexcharts@4.3.0/dist/apexcharts.min.js";
    hash = "sha256-zceUTsCKa8Y2SqjqZjLjifXQDnqsvKRTmT8fTIUix/4=";
  };
  tablerCss = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0-beta20/dist/css/tabler.min.css";
    hash = "sha256-lS3nKxMMZiKIRJG7UgUonOHYuvHgW5eckEjvHMYxb9Q=";
  };
  tablerVendorsCss = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0-beta20/dist/css/tabler-vendors.min.css";
    hash = "sha256-Aa7AUOaz6hJLiUzQStZTy2VPOZyg0ViSo2MCzpDU1tY=";
  };
  tablerJs = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0-beta21/dist/js/tabler.min.js";
    hash = "sha256-c01wM5Q9GIKYbvvjIaxt67o1CpIBkFMMmz1Dgsi0K7A=";
  };
  tablerIcons = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/@tabler/icons-sprite@3.21.0/dist/tabler-sprite.svg";
    hash = "sha256-TUlx6LLnZ7sDN7Xzt+/zAuxLYgUkQSqRgdQm8H4cohY=";
  };
  tomselect = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/tom-select@2.4.1/dist/js/tom-select.popular.min.js";
    hash = "sha256-Cb1Xmb9qQO8I1mMVkz4t2bT8l7HX+1JeKncGBSytSHQ=";
  };
in

rustPlatform.buildRustPackage rec {
  pname = "sqlpage";
  version = "0.32.1";

  src = fetchFromGitHub {
    owner = "lovasoa";
    repo = "SQLpage";
    tag = "v${version}";
    hash = "sha256-PfBZCfwXL5/ItBFrEod27BIuWbWR9gVGTfbdxQ/IIuQ=";
  };

  postPatch = ''
    substituteInPlace sqlpage/apexcharts.js \
      --replace-fail '/* !include https://cdn.jsdelivr.net/npm/apexcharts@4.3.0/dist/apexcharts.min.js */' \
      "$(cat ${apexcharts})"
    substituteInPlace sqlpage/sqlpage.css \
      --replace-fail '/* !include https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0-beta20/dist/css/tabler.min.css */' \
      "$(cat ${tablerCss})"
    substituteInPlace sqlpage/sqlpage.css \
      --replace-fail '/* !include https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0-beta20/dist/css/tabler-vendors.min.css */' \
      "$(cat ${tablerVendorsCss})"
    substituteInPlace sqlpage/sqlpage.js \
      --replace-fail '/* !include https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0-beta21/dist/js/tabler.min.js */' \
      "$(cat ${tablerJs})"
    substituteInPlace sqlpage/tabler-icons.svg \
      --replace-fail '/* !include https://cdn.jsdelivr.net/npm/@tabler/icons-sprite@3.21.0/dist/tabler-sprite.svg */' \
      "$(cat ${tablerIcons})"
    substituteInPlace sqlpage/tomselect.js \
      --replace-fail '/* !include https://cdn.jsdelivr.net/npm/tom-select@2.4.1/dist/js/tom-select.popular.min.js */' \
      "$(cat ${tomselect})"
  '';

  useFetchCargoVendor = true;

  cargoHash = "sha256-HbNVBMysowIV62l7eSHu4YaBMIku+IT11jlEgWrjaWE=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    sqlite
    zstd
  ];

  env.ZSTD_SYS_USE_PKG_CONFIG = true;

  meta = {
    description = "SQL-only webapp builder, empowering data analysts to build websites and applications quickly";
    homepage = "https://github.com/lovasoa/SQLpage";
    changelog = "https://github.com/lovasoa/SQLpage/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dit7ya ];
    mainProgram = "sqlpage";
  };
}
