{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  fontconfig,
  writableTmpDirAsHomeHook,
  writeShellApplication,
  hdr10plus,
  nixVersions,
  nix-update,
  tomlq,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hdr10plus_tool";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "quietvoid";
    repo = "hdr10plus_tool";
    tag = finalAttrs.version;
    hash = "sha256-eueB+ZrOrnySEwUpCTvC4qARCsDcHJhm088XepLTlOE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-3D0HjDtKwYoi9bpQnosC/TPNBjfiWi5m1CH1eGQpGg0=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ fontconfig ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];
  preCheck = ''
    export FONTCONFIG_FILE="${fontconfig.out}/etc/fonts/fonts.conf";
  '';

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "update-${finalAttrs.pname}";
    runtimeInputs = [
      nixVersions.latest
      nix-update
      tomlq
    ];

    text = ''
      nix-update ${finalAttrs.pname}
      src="$(nix eval -f . --raw ${finalAttrs.pname}.src)"
      libver="$(tq -f "$src/hdr10plus/Cargo.toml" package.version)"
      nix-update ${hdr10plus.pname} --version "$libver"
    '';
  });

  meta = {
    description = "CLI utility to work with HDR10+ in HEVC files.";
    homepage = "https://github.com/quietvoid/hdr10plus_tool";
    changelog = "https://github.com/quietvoid/hdr10plus_tool/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ johnrtitor ];
    mainProgram = "hdr10plus_tool";
  };
})
