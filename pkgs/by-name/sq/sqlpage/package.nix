{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  sqlite,
  unixODBC,
  zstd,
  fetchurl,
}:

let
  apexcharts = {
    url = "https://cdn.jsdelivr.net/npm/apexcharts@5.3.6/dist/apexcharts.min.js";
    hash = "sha256-qNJtESJROYHRKwS/u3zdu4Fev69db17hKHZvrqGiqRs=";
  };
  tablerCss = {
    url = "https://cdn.jsdelivr.net/npm/@tabler/core@1.4.0/dist/css/tabler.min.css";
    hash = "sha256-fvdQvRBUamldCxJ2etgEi9jz7F3n2u+xBn+dDao9HJo=";
  };
  tomSelectCss = {
    url = "https://cdn.jsdelivr.net/npm/tom-select@2.4.3/dist/css/tom-select.bootstrap5.css";
    hash = "sha256-vW5UjM/Ka9/jIY8I5s5KcudaTRWh/cCGE1ZUsrJvlI0=";
  };
  tablerVendorsCss = {
    url = "https://cdn.jsdelivr.net/npm/@tabler/core@1.4.0/dist/css/tabler-vendors.min.css";
    hash = "sha256-/VPz9GtiH1Es1KGLY706UIayEEgG93B6aIBa3WzwKYc=";
  };
  tablerJs = {
    url = "https://cdn.jsdelivr.net/npm/@tabler/core@1.4.0/dist/js/tabler.min.js";
    hash = "sha256-tgx2Fg6XYkV027jPEKvmrummSTtgCW/fwV3R3SvZnrk=";
  };
  tablerIcons = {
    url = "https://cdn.jsdelivr.net/npm/@tabler/icons-sprite@3.34.0/dist/tabler-sprite.svg";
    hash = "sha256-pCPkhrx0GnPg5/EthJ7pLdMxb7wbYMJ0R7WchDcffpg=";
  };
  tomselect = {
    url = "https://cdn.jsdelivr.net/npm/tom-select@2.4.1/dist/js/tom-select.popular.min.js";
    hash = "sha256-Cb1Xmb9qQO8I1mMVkz4t2bT8l7HX+1JeKncGBSytSHQ=";
  };
in

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sqlpage";
  version = "0.41.0";

  src = fetchFromGitHub {
    owner = "lovasoa";
    repo = "SQLpage";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rUij1nhXcLEwdUUVpKoUbgNqV47TvmMCEds4ihP9QL4=";
  };

  postPatch = ''
    substituteInPlace sqlpage/apexcharts.js \
      --replace-fail '/* !include ${apexcharts.url} */' \
      "$(cat ${fetchurl apexcharts})"
    substituteInPlace sqlpage/sqlpage.css \
      --replace-fail '/* !include ${tablerCss.url} */' \
      "$(cat ${fetchurl tablerCss})" \
      --replace-fail '/* !include ${tablerVendorsCss.url} */' \
      "$(cat ${fetchurl tablerVendorsCss})" \
      --replace-fail '/* !include ${tomSelectCss.url} */' \
      "$(cat ${fetchurl tomSelectCss})"
    substituteInPlace sqlpage/sqlpage.js \
      --replace-fail '/* !include ${tablerJs.url} */' \
      "$(cat ${fetchurl tablerJs})"
    substituteInPlace sqlpage/tabler-icons.svg \
      --replace-fail '/* !include ${tablerIcons.url} */' \
      "$(cat ${fetchurl tablerIcons})"
    substituteInPlace sqlpage/tomselect.js \
      --replace-fail '/* !include ${tomselect.url} */' \
      "$(cat ${fetchurl tomselect})"
    substituteInPlace build.rs \
      --replace-fail "https://cdn.jsdelivr.net/npm/@tabler/icons-sprite@3.35.0/dist/tabler-sprite.svg" "${fetchurl tablerIcons}" \
      --replace-fail "copy_url_to_opened_file(&client, sprite_url, &mut sprite_content).await;" "sprite_content = std::fs::read(sprite_url).unwrap();"
  '';

  cargoHash = "sha256-jyhvhViPz/tj76mvmaIih4LaCH+ODFa8gs0/MTYbuQg=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    sqlite
    unixODBC
    zstd
  ];

  env.ZSTD_SYS_USE_PKG_CONFIG = true;

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "SQL-only webapp builder, empowering data analysts to build websites and applications quickly";
    homepage = "https://github.com/lovasoa/SQLpage";
    changelog = "https://github.com/lovasoa/SQLpage/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dit7ya ];
    mainProgram = "sqlpage";
  };
})
