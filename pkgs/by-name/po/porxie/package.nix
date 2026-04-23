{
  lib,
  fetchFromCodeberg,
  rustPlatform,
  nixosTests,
  stdenvNoCC,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "porxie";
  version = "0.1.0";

  src = fetchFromCodeberg {
    owner = "Blooym";
    repo = "porxie";
    rev = "v${finalAttrs.version}";
    hash = "sha256-TxN9BA/o9BI9yF7k3wpJae78hIcCAhB/ggXVQlt4oP0=";
  };
  cargoHash = "sha256-a0Ps8SvheQoX+Ai8EYgEpyTFwNvB7E3J6MfGiyEvMzM=";

  passthru = {
    updateScript = nix-update-script { };
    tests = lib.optionalAttrs stdenvNoCC.hostPlatform.isLinux {
      porxie = nixosTests.porxie;
    };
  };

  meta = {
    description = "Porxie, an ATProto blob proxy for secure content delivery";
    homepage = "https://codeberg.org/Blooym/porxie";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ blooym ];
    mainProgram = "porxie";
    platforms = lib.platforms.unix;
  };
})
