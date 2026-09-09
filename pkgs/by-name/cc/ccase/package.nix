{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ccase";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "stringcase";
    repo = "ccase";
    tag = finalAttrs.version;
    hash = "sha256-VkykOOMHUsJhfktNRfHx+kvB2331PPhT5pW5bX+kLng=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-gi7CR5UUD+qUQ6wx0XepzyHHq9RH7SnsMXIKV4JoiQg=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command line interface to convert strings into any case";
    homepage = "https://github.com/stringcase/ccase";
    changelog = "https://github.com/stringcase/ccase/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "ccase";
    maintainers = with lib.maintainers; [ musjj ];
  };
})
