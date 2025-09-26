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
      dbtHash = "sha256-5E7/XzLvEQBM9R/EaJm0KKIYL7JjjedLSDQAceGqzQs=";
      lspHash = "sha256-86V9u4LM4hzHL+Kw+2FxFYIzfAtOqPdo0PimI/f0+s8=";
    };
    "aarch64-linux" = {
      name = "aarch64-unknown-linux-gnu";
      dbtHash = "sha256-+3H4OUaOINnp8EqHtO1xp/jj0yxQx8wh0Pwhs7tEaOI=";
      lspHash = "sha256-Dse1jxD+1zPFX/tvzv+C1+UuTycYcurpf7SRpv4NM/o=";
    };
    "x86_64-darwin" = {
      name = "x86_64-apple-darwin";
      dbtHash = "sha256-Nww2/Xhed7g+AEmHPkClsjZa+EPIltFl2grjx5DLSNo=";
      lspHash = "sha256-Qq3Pgu6N8p33NQ6Do32SsJoK1uevLrBRDPwWkso6rB8=";
    };
    "aarch64-darwin" = {
      name = "aarch64-apple-darwin";
      dbtHash = "sha256-Nj7SlbNsCNhfWCi/AEt+hNJrg6Gp1x+GD8cBrVWTgJs=";
      lspHash = "sha256-RFPjAYvpAPtnbcMiXVETrvYjDkJ8kMFEatrxgRjqQQ0=";
    };
  };
  platform = systemToPlatform.${system} or throwSystem;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dbt-fusion";
  version = "2.0.0-beta.33";

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
