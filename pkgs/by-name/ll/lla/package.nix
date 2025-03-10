{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeBinaryWrapper,
  versionCheckHook,
  nix-update-script,
}:
let
  version = "0.3.10";
in
rustPlatform.buildRustPackage {
  pname = "lla";
  inherit version;

  src = fetchFromGitHub {
    owner = "chaqchase";
    repo = "lla";
    tag = "v${version}";
    hash = "sha256-/6p23JW3ZaSuDf34IWcTggR92/zUTMRerQ32bTsRujo=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-aX8nm/V0ug2g40QeFU9AWxjuFAnW+gYTR8RC5CV7wRQ=";

  cargoBuildFlags = [ "--workspace" ];

  postFixup = ''
    wrapProgram $out/bin/lla \
      --add-flags "--plugins-dir $out/lib"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Blazing-fast `ls` replacement with superpowers";
    longDescription = ''
      `lla` is a modern `ls` replacement that transforms how developers interact with their filesystem.
      Built with Rust's performance capabilities and designed with user experience in mind,
      `lla` combines the familiarity of ls with powerful features like specialized views,
      Git integration, and a robust plugin system with an extensible list of plugins to add more functionality.
    '';
    homepage = "https://lla.chaqchase.com";
    changelog = "https://github.com/chaqchase/lla/blob/refs/tags/v${version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ pluiedev ];
    platforms = lib.platforms.unix;
    mainProgram = "lla";
  };
}
