{
  lib,
  rustPlatform,
  fetchFromGitHub,
  runCommand,
  jq,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "harbor-cad";
  version = "0.1.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "caniko";
    repo = "harbor-cad";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pkEgx/YWINWql5/EakDSt/QCLDDSVrCY7ihp5WHM3ss=";
  };

  cargoHash = "sha256-IQ78RLc9EuC29ZjKjexvWD2RABlYXejgRcLviInJXuY=";

  postInstall = ''
    install -Dm444 profiles/ci.json -t $out/share/harbor-cad/profiles
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    # Submits, polls and describes the CPU reference job on a foreground CI-profile worker.
    tests.ci-reference =
      runCommand "harbor-cad-ci-reference"
        {
          nativeBuildInputs = [
            finalAttrs.finalPackage
            jq
          ];
          profile = "${finalAttrs.finalPackage}/share/harbor-cad/profiles/ci.json";
        }
        ''
          state=$TMPDIR/state
          harbor-cad worker --state "$state" --profile "$profile" &
          worker=$!
          trap 'kill $worker' EXIT
          for _ in $(seq 100); do [ -S "$state/worker.sock" ] && break; sleep 0.1; done
          harbor-cad case init > case.json
          harbor-cad case plan case.json > planned.json
          jq .plan planned.json > plan.json
          id=$(harbor-cad --socket "$state/worker.sock" job submit plan.json \
            --approve "$(jq -r .approval_digest planned.json)" --idempotency-key reference \
            | jq -r .data.id)
          for _ in $(seq 600); do
            status=$(harbor-cad --socket "$state/worker.sock" job status "$id" | jq -r .data.state)
            case $status in succeeded | failed | cancelled) break ;; esac
            sleep 0.1
          done
          [ "$status" = succeeded ]
          harbor-cad --socket "$state/worker.sock" results describe "$id" > $out
        '';
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Local scientific CAD job worker with explicit qualification gates";
    homepage = "https://github.com/caniko/harbor-cad";
    changelog = "https://github.com/caniko/harbor-cad/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ caniko ];
    mainProgram = "harbor-cad";
    platforms = lib.platforms.linux;
  };
})
