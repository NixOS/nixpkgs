{
  lib,
  rustPlatform,
  hdr10plus_tool,
  cargo-c,
  fontconfig,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "hdr10plus";
  # Version of the library, not the tool
  # See https://github.com/quietvoid/hdr10plus_tool/blob/main/hdr10plus/Cargo.toml
  version = "2.1.4";

  outputs = [
    "out"
    "dev"
  ];

  inherit (hdr10plus_tool) src cargoDeps cargoHash;

  nativeBuildInputs = [ cargo-c ];
  buildInputs = [ fontconfig ];

  dontCargoBuild = true;
  dontCargoInstall = true;
  dontCargoCheck = true;

  cargoCFlags = [
    "--package=hdr10plus"
  ];

  passthru.tests = {
    inherit hdr10plus_tool;
  };

  meta = {
    description = "Library to work with HDR10+ in HEVC files";
    homepage = "https://github.com/quietvoid/hdr10plus_tool";
    changelog = "https://github.com/quietvoid/hdr10plus_tool/releases/tag/${hdr10plus_tool.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mvs ];
    pkgConfigModules = [ "hdr10plus-rs" ];
  };
})
