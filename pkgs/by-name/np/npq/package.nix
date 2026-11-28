{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchurl,
  buildNpmPackage,
  versionCheckHook,
  nix-update-script,
}:
buildNpmPackage (finalAttrs: {
  pname = "npq";
  version = "3.27.5";

  src = fetchFromGitHub {
    owner = "lirantal";
    repo = "npq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BAjPRkjKYy8PIZ+wNnlbLMMNUL1hb9ucQfhgandrfro=";
  };

  topPackagesFile = fetchurl {
    # Note: There is only one tag called `latest`. Therefore, it cannot be pinned to a specific version.
    url = "https://github.com/lirantal/npm-rank/releases/download/latest/list-package-names.json";
    hash = "sha256-5EXd3kyhCUFXG/7pUxcs6FS7sRAZfRX0nNbzblCtkGI=";
  };

  # Skip the original npm build script
  dontNpmBuild = true;

  # npq uses semantic-release in CI so we need to patch the version in package.json and package-lock.json
  postPatch = ''
    echo "Patching package.json version to ${finalAttrs.version}..."
    substituteInPlace package*.json \
      --replace-fail '"version": "0.0.0-development"' '"version": "${finalAttrs.version}"'
  '';

  # This substitutes the original npm build script
  preInstall = ''
    echo "Copying list-package-names.json to data directory..."
    cp ${finalAttrs.topPackagesFile} ./data/list-package-names.json
  '';

  stdenv = stdenvNoCC;

  npmDepsHash = "sha256-kmSfsBoULFrqiscamBk30UhNWVWtSXJM6kcGfxEVwNY=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Marshall your npm/npm package installs";
    homepage = "https://github.com/lirantal/npq";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kynsonszetau ];
    changelog = "https://github.com/lirantal/npq/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "npq";
  };
})
