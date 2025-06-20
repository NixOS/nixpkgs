{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
  libgcc,
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";
  systemToPlatform = {
    "x86_64-linux" = {
      name = "x86_64-unknown-linux-gnu";
      dbtHash = "sha256-aL4y+PssRm2e0v0LYKw2nh8zQpwEnKVB12ziqFC7O6A=";
      lspHash = "sha256-MU4aK9oXU+MS6MFx0zbfsxVPV9lNmjAUqYf1plOgaN4=";
    };
    "aarch64-linux" = {
      name = "aarch64-unknown-linux-gnu";
      dbtHash = "sha256-0SY0mMVZ2IdlJmvZXbSxl+YqFJWf8SeM5PP29urBx4I=";
      lspHash = "sha256-oiKyVzaNLA/xxyNotvR4jC9V/f9ejSUHZA4zKn4N9Lk=";
    };
    "x86_64-darwin" = {
      name = "x86_64-apple-darwin";
      dbtHash = "sha256-Lo0K1yiQI3s8PLDvZDfmNtWqU1+GmqVAIuC30BkO5J4=";
      lspHash = "sha256-2tLx76OqefHOW3qvAgqtqgRXaAVwTaDNYXFaaXKiMRw=";
    };
    "aarch64-darwin" = {
      name = "aarch64-apple-darwin";
      dbtHash = "sha256-c4fB1McmGytFQbPzGx1oL6glI7r+3EUNPxOmKcdRddw=";
      lspHash = "sha256-vnQIe/8GqT1SSg9FSDyHoEEVGNZc3STPhH56AzKipHo=";
    };
  };
  platform = systemToPlatform.${system} or throwSystem;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dbt-fusion";
  version = "2.0.0-beta.22";

  srcs = [
    (fetchurl {
      url = "https://public.cdn.getdbt.com/fs/cli/fs-v${finalAttrs.version}-${platform.name}.tar.gz";
      hash = platform.dbtHash;
    })
    (fetchurl {
      url = "https://public.cdn.getdbt.com/fs/lsp/fs-lsp-v${finalAttrs.version}-${platform.name}.tar.gz";
      hash = platform.lspHash;
    })
  ];

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = [ libgcc ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    install -m755 -D dbt $out/bin/dbtf
    install -m755 -D dbt-lsp $out/bin/dbt-lsp
    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    changelog = "https://github.com/dbt-labs/dbt-fusion/blob/main/CHANGELOG.md";
    description = "Next-generation engine for dbt";
    homepage = "https://github.com/dbt-labs/dbt-fusion";
    license = lib.licenses.elastic20;
    mainProgram = "dbtf";
    maintainers = with lib.maintainers; [ dbreyfogle ];
    platforms = lib.attrNames systemToPlatform;
  };
})
