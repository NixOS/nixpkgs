{
  lib,
  buildNpmPackage,
  fetchFromGitHub,

  nix-update-script,
}:

buildNpmPackage rec {
  pname = "husky";
  version = "9.1.7";

  src = fetchFromGitHub {
    owner = "typicode";
    repo = "husky";
    rev = "v${version}";
    hash = "sha256-rjj6kG0f9dbwc3MOS3sXBp1tNOfbOgWAQzm7MbImMk8=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/node_modules/husky
    cp {index,bin}.js $out/lib/node_modules/husky

    mkdir -p $out/bin
    ln -s $out/lib/node_modules/husky/bin.js $out/bin/husky

    chmod +x $out/lib/node_modules/husky/bin.js

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
    changelog = "https://github.com/typicode/husky/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dit7ya
      mrdev023
    ];
  };
}
