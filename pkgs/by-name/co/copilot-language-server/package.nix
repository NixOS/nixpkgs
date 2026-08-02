{
  lib,
  stdenvNoCC,
  makeWrapper,
  fetchzip,
  nix-update-script,
  nodejs,

  testers,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "copilot-language-server";
  version = "1.527.1";

  src = fetchzip {
    url = "https://github.com/github/copilot-language-server-release/releases/download/${finalAttrs.version}/copilot-language-server-js-${finalAttrs.version}.zip";
    hash = "sha256-RLcfAld0vJYyE6ndqwkFqfJNNWD/PmoNQy8NWDRBa6g=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    nodejs
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/copilot-language-server
    cp -r ./* $out/share/copilot-language-server/

    makeWrapper ${lib.getExe nodejs} $out/bin/copilot-language-server \
      --add-flags $out/share/copilot-language-server/main.js

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
  };

  meta = {
    description = "Use GitHub Copilot with any editor or IDE via the Language Server Protocol";
    homepage = "https://github.com/features/copilot";
    license = {
      deprecated = false;
      free = false;
      fullName = "GitHub Copilot Product Specific Terms";
      redistributable = false;
      shortName = "GitHub Copilot License";
      url = "https://github.com/customer-terms/github-copilot-product-specific-terms";
    };
    mainProgram = "copilot-language-server";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [
      arunoruto
      wattmto
    ];
  };
})
