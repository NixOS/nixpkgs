{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitUpdater,
  writeShellApplication,
  _experimental-update-script-combinators,
  galene,
  nix,
  sd,
}:

buildGoModule (finalAttrs: {
  pname = "galene-ldap";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "jech";
    repo = "galene-ldap";
    tag = "galene-ldap-${finalAttrs.version}";
    hash = "sha256-FXD90ishU3FBRj16tQx8wr+lSFl1dffNM1rU81Kfe1I=";
  };

  vendorHash = "sha256-i/pWXgcd01PgH1Q+WEm0gP1leTFBhqGxVGnl6c+J1aQ=";

  strictDeps = true;

  ldflags = [
    "-s"
    "-w"
  ];

  passthru = {
    updateScriptSrc = gitUpdater {
      rev-prefix = "galene-ldap-";
    };
    updateScriptVendor = writeShellApplication {
      name = "update-galene-ldap-vendorHash";
      runtimeInputs = [
        nix
        sd
      ];
      text = ''
        export UPDATE_NIX_ATTR_PATH="''${UPDATE_NIX_ATTR_PATH:-galene-ldap}"

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
    description = "LDAP support for the Galene videoconferencing server";
    homepage = "https://github.com/jech/galene-ldap";
    changelog = "https://github.com/jech/galene-ldap/raw/${finalAttrs.src.rev}/CHANGES";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    inherit (galene.meta) maintainers;
  };
})
