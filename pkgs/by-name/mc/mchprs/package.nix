{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  sqlite,
  zlib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mchprs";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "MCHPR";
    repo = "MCHPRS";
    tag = "v${finalAttrs.version}";
    hash = "sha256-glAJtm0hIQHBdm0O70DVVM/RjdMOGNsD3Zytin8Uxa8=";
  };

  cargoHash = "sha256-n7LWU76nz8c69XBUa38gRfS6/t9bBcGHtf+hDAAweAg=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    openssl
    sqlite
    zlib
  ];

  meta = {
    mainProgram = "mchprs";
    description = "Multithreaded Minecraft server built for redstone";
    homepage = "https://github.com/MCHPR/MCHPRS";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gdd ];
  };
})
