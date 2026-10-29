{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitUpdater,
  nixosTests,
  writeShellApplication,
  _experimental-update-script-combinators,
  galene,
  nix,
  sd,
}:

buildGoModule (finalAttrs: {
  pname = "galene-file-transfer";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "jech";
    repo = "galene-file-transfer";
    tag = "galene-file-transfer-${finalAttrs.version}";
    hash = "sha256-T3OtEsHysAmHwvDIkxqXMKLqIeXEeX9uhEG4WFUgQL4=";
  };

  vendorHash = "sha256-Z2IYZtB2PAxJD8993reu+ldTG3LdPLNMbr9pP2NUBMA=";

  strictDeps = true;

  ldflags = [
    "-s"
    "-w"
  ];

  passthru = {
    tests.vm = nixosTests.galene.file-transfer;
    updateScriptSrc = gitUpdater {
      rev-prefix = "galene-file-transfer-";
    };
    updateScriptVendor = writeShellApplication {
      name = "update-galene-file-transfer-vendorHash";
      runtimeInputs = [
        nix
        sd
      ];
      text = ''
        export UPDATE_NIX_ATTR_PATH="''${UPDATE_NIX_ATTR_PATH:-galene-file-transfer}"

        oldhash="$(nix-instantiate . --eval --strict -A "$UPDATE_NIX_ATTR_PATH.goModules.drvAttrs.outputHash" | cut -d'"' -f2)"
        newhash="$(nix-build -A "$UPDATE_NIX_ATTR_PATH.goModules" --no-out-link 2>&1 | tail -n3 | grep 'got:' | cut -d: -f2- | xargs echo || true)"

        if [ "$newhash" == "" ]; then
          echo "No new vendorHash."
          exit 0
        fi

        fname="$(nix-instantiate --eval -E "with import ./. {}; (builtins.unsafeGetAttrPos \"version\" $UPDATE_NIX_ATTR_PATH).file" | cut -d'"' -f2)"

        ${sd.meta.mainProgram} --string-mode "$oldhash" "$newhash" "$fname"
      '';
    };
    updateScript = _experimental-update-script-combinators.sequence [
      finalAttrs.passthru.updateScriptSrc.command
      (lib.getExe finalAttrs.passthru.updateScriptVendor)
    ];
  };

  meta = {
    description = "Command-line file transfer client for the Galene videoconferencing server";
    homepage = "https://github.com/jech/galene-file-transfer";
    changelog = "https://github.com/jech/galene-file-transfer/raw/${finalAttrs.src.rev}/CHANGES";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    inherit (galene.meta) maintainers;
  };
})
