{
  lib,
  buildNpmPackage,
  fetchFromGitHub,

  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "husky";
  version = "9.1.7";

  src = fetchFromGitHub {
    owner = "typicode";
    repo = "husky";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rjj6kG0f9dbwc3MOS3sXBp1tNOfbOgWAQzm7MbImMk8=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -Dm755 bin.js husky -t $out/lib/node_modules/husky
    install -Dm644 index.js -t $out/lib/node_modules/husky
    ln -s ../lib/node_modules/husky/bin.js $out/bin/husky

    runHook postInstall
  '';

  # The project is dependency free
  dontNpmBuild = true;
  forceEmptyCache = true;
  npmDepsHash = "sha256-68/85gX0/9wZNOTpiy3AHqTW6FU9RoaeCKf8IQPOqys=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Git hooks made easy";
    mainProgram = "husky";
    homepage = "https://github.com/typicode/husky";
    changelog = "https://github.com/typicode/husky/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      iamanaws
      mrdev023
    ];
  };
})
