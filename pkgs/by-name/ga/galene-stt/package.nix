{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitUpdater,
  writeShellApplication,
  _experimental-update-script-combinators,
  galene,
  libopus,
  nix,
  pkg-config,
  sd,
  whisper-cpp,
}:

buildGoModule (finalAttrs: {
  pname = "galene-stt";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "jech";
    repo = "galene-stt";
    tag = "galene-stt-${finalAttrs.version}";
    hash = "sha256-uW1b5T+p7KGvqt+PlR9d7bo62V+URHniS45sZP/VuLQ=";
  };

  vendorHash = "sha256-UFOxo8jq+gxN1dkM2A/BQqtT9ggIp7qovFRLv3Q6Io0=";

  # Not necessary, but feels cleaner to pull it in like that
  postPatch = ''
    substituteInPlace whisper.go \
      --replace-fail 'cgo LDFLAGS: -lwhisper' 'cgo pkg-config: whisper'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libopus
    whisper-cpp
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  passthru = {
    updateScriptSrc = gitUpdater {
      rev-prefix = "galene-stt-";
    };
    updateScriptVendor = writeShellApplication {
      name = "update-galene-stt-vendorHash";
      runtimeInputs = [
        nix
        sd
      ];
      text = ''
        export UPDATE_NIX_ATTR_PATH="''${UPDATE_NIX_ATTR_PATH:-galene-stt}"

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
    description = "Speech-to-text support for Galene";
    homepage = "https://github.com/jech/galene-stt";
    changelog = "https://github.com/jech/galene-stt/raw/${finalAttrs.src.rev}/CHANGES";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    inherit (galene.meta) maintainers;
  };
})
