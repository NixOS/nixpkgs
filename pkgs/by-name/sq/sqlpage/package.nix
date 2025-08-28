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
    url = "https://cdn.jsdelivr.net/npm/apexcharts@4.5.0/dist/apexcharts.min.js";
    hash = "sha256-D19uY7rZtzJPVsZWYpvTOoY2hXmgfg+Mlaf+ALYHTgg=";
  };
  tablerCss = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0/dist/css/tabler.min.css";
    hash = "sha256-aO+4ZoyNPZHCexbbprDYU9LCxshqszQA0SINFYfos3M=";
  };
  tablerVendorsCss = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0/dist/css/tabler-vendors.min.css";
    hash = "sha256-MyRhKcnB54KIswGkkyYXzEjx3YPVTKG7zVBf4wE20QY=";
  };
  tablerJs = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0/dist/js/tabler.min.js";
    hash = "sha256-QoGNzPGpYrbyDynQUZxmnFFT8MEk/nkUCLyp71avhqw=";
  };
  tablerIcons = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/@tabler/icons-sprite@3.30.0/dist/tabler-sprite.svg";
    hash = "sha256-CD5BvpwW4Db6C7bxjaWUrA3kz17BDJKVU4bTwOPP1kE=";
  };
  tomselect = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/tom-select@2.4.1/dist/js/tom-select.popular.min.js";
    hash = "sha256-Cb1Xmb9qQO8I1mMVkz4t2bT8l7HX+1JeKncGBSytSHQ=";
  };
in

rustPlatform.buildRustPackage rec {
  pname = "sqlpage";
  version = "0.34.0";

  src = fetchFromGitHub {
    owner = "lovasoa";
    repo = "SQLpage";
    tag = "v${version}";
    hash = "sha256-cqMXdAXc46DbbONz1A6uf2Oo2Cu4sig6ntuLqYlihR4=";
  };

  postPatch = ''
    substituteInPlace sqlpage/apexcharts.js \
      --replace-fail '/* !include https://cdn.jsdelivr.net/npm/apexcharts@4.5.0/dist/apexcharts.min.js */' \
      "$(cat ${apexcharts})"
    substituteInPlace sqlpage/sqlpage.css \
      --replace-fail '/* !include https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0/dist/css/tabler.min.css */' \
      "$(cat ${tablerCss})"
    substituteInPlace sqlpage/sqlpage.css \
      --replace-fail '/* !include https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0/dist/css/tabler-vendors.min.css */' \
      "$(cat ${tablerVendorsCss})"
    substituteInPlace sqlpage/sqlpage.js \
      --replace-fail '/* !include https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0/dist/js/tabler.min.js */' \
      "$(cat ${tablerJs})"
    substituteInPlace sqlpage/tabler-icons.svg \
      --replace-fail '/* !include https://cdn.jsdelivr.net/npm/@tabler/icons-sprite@3.30.0/dist/tabler-sprite.svg */' \
      "$(cat ${tablerIcons})"
    substituteInPlace sqlpage/tomselect.js \
      --replace-fail '/* !include https://cdn.jsdelivr.net/npm/tom-select@2.4.1/dist/js/tom-select.popular.min.js */' \
      "$(cat ${tomselect})"
  '';

  cargoHash = "sha256-NUbCSYUTXN8glw94Lr/+Jj54PukRXFlzTxq0d7znjwA=";

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
