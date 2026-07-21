{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  sqlite,
  zlib,
  python3,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "prqlc";
  version = "0.13.13";

  src = fetchFromGitHub {
    owner = "prql";
    repo = "prql";
    tag = finalAttrs.version;
    hash = "sha256-/5z8i65WpLl06uYqu+PD/fMyajeHiECbzdgTD6D4M20=";
  };

  cargoHash = "sha256-vQOcdDnNPC6dcHbr3GgsE/seokiormNK1oi6E9JrcTY=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    openssl
    sqlite
    zlib
  ];

  env.PYO3_PYTHON = "${python3}/bin/python3";

  # we are only interested in the prqlc binary
  postInstall = ''
    rm -r $out/bin/compile-files $out/bin/mdbook-prql $out/lib
  '';

  meta = {
    description = "CLI for the PRQL compiler - a simple, powerful, pipelined SQL replacement";
    homepage = "https://github.com/prql/prql";
    changelog = "https://github.com/prql/prql/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hythera ];
  };
})
