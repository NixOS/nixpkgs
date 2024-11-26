{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeBinaryWrapper,
  versionCheckHook,
  nix-update-script,
}:
let
  version = "0.2.10";
in
rustPlatform.buildRustPackage {
  pname = "lla";
  inherit version;

  src = fetchFromGitHub {
    owner = "triyanox";
    repo = "lla";
    rev = "refs/tags/v${version}";
    hash = "sha256-zHtHlEAh170t05DO5b/vspODkqx5G9C3nt5G8dtm8wI=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  cargoHash = "sha256-ar7NEQKTdxM96dT9b9BBfYZA3zVlhN6OciKRo4ZhBSU=";

  cargoBuildFlags = [ "--workspace" ];

  postFixup = ''
    wrapProgram $out/bin/lla \
      --add-flags "--plugins-dir $out/lib"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern alternative to ls";
    longDescription = ''
      `lla` is a high-performance, extensible alternative to the traditional ls command, written in Rust.
      It offers enhanced functionality, customizable output, and a plugin system for extended capabilities.
    '';
    homepage = "https://github.com/triyanox/lla";
    changelog = "https://github.com/triyanox/lla/blob/refs/tags/v${version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ pluiedev ];
    platforms = lib.platforms.unix;
    mainProgram = "lla";
  };
}
