{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

stdenvNoCC.mkDerivation rec {
  pname = "safehouse";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "eugene1g";
    repo = "agent-safehouse";
    rev = "v" + version;
    hash = "sha256-2GWxh5J9qqudc2QM/CACXpqJLcNULKSfTAHBzR++UAE=";
  };

  postPatch = "patchShebangs scripts bin";

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  buildPhase = ''
    runHook preBuild
    scripts/generate-dist.sh
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 dist/safehouse.sh $out/bin/safehouse

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Sandbox your local AI agents so they can read/write only what they need";
    homepage = "https://github.com/eugene1g/agent-safehouse";
    mainProgram = "safehouse";
    license = lib.licenses.asl20;
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      myzel394
      Br1ght0ne
    ];
  };
}
