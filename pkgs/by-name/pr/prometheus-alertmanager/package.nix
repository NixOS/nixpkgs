{
  lib,
  go,
  buildGoModule,
  callPackage,
  fetchFromGitHub,
  fetchpatch,
  installShellFiles,
  nixosTests,
  versionCheckHook,
  common-updater-scripts,
  curlMinimal,
  elm2nix,
  nix-update,
  nixfmt,
  writeShellApplication,
}:

let
  elmUi = callPackage ./elm-ui.nix { };
in
buildGoModule (finalAttrs: {
  pname = "alertmanager";
  version = "0.33.1";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "alertmanager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LGjBuZ7kbtABunEk2YyCKILsPS/0FlS/6Mf/2qVpseI=";
  };

  patches = [
    # https://github.com/prometheus/alertmanager/pull/5254
    (fetchpatch {
      url = "https://github.com/prometheus/alertmanager/commit/bccb5e5e9b97f7170712305691d2b6d652c97f83.patch";
      includes = [ "notify/telegram/telegram.go" ];
      # The released source predates this error-classification helper.
      decode = "sed -e 's/wrapWithFailureReason(err)/err/g' -e 's/wrapWithFailureReason(notify.RedactURL(err))/notify.RedactURL(err)/g'";
      hash = "sha256-DGbNdTOLyJOprzgf0DMv36cEVbnebWPWCTMcV7oRfsY=";
    })
    ./telegram-redact-send-url-test.patch
  ];

  postPatch = ''
    cp -r ${elmUi}/. ui/app/dist
  '';
  vendorHash = "sha256-t5jQtccln3dfcHlnEOnLQHfjzfU9kY9Y7q+r4AigvBE=";

  subPackages = [
    "cmd/alertmanager"
    "cmd/amtool"
  ];

  # subPackages limits checkPhase to cmd/, so run the backported regression test explicitly.
  postCheck = ''
    go test ./notify/telegram/ -run '^TestTelegramNotifyRedactsSendURL$'
  '';

  # The regression test binds an httptest server on loopback.
  __darwinAllowLocalNetworking = true;

  ldflags =
    let
      t = "github.com/prometheus/common/version";
    in
    [
      "-X ${t}.Version=${finalAttrs.version}"
      "-X ${t}.Revision=unknown"
      "-X ${t}.Branch=unknown"
      "-X ${t}.BuildUser=nix@nixpkgs"
      "-X ${t}.BuildDate=unknown"
      "-X ${t}.GoVersion=${lib.getVersion go}"
    ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    $out/bin/amtool --completion-script-bash > amtool.bash
    installShellCompletion amtool.bash
    $out/bin/amtool --completion-script-zsh > amtool.zsh
    installShellCompletion amtool.zsh
  '';

  passthru = {
    inherit elmUi;
    tests = { inherit (nixosTests.prometheus) alertmanager; };
    updateScript = lib.getExe (writeShellApplication {
      name = "alertmanager-update";
      runtimeInputs = [
        curlMinimal
        common-updater-scripts
        elm2nix
        nix-update
        nixfmt
      ];
      text = ''
        TAG=$(list-git-tags --url="https://github.com/${finalAttrs.src.owner}/${finalAttrs.src.repo}" | sort -V | tail -n1)

        pushd pkgs/by-name/pr/prometheus-alertmanager
        wcurl --output="elm.json" "https://raw.githubusercontent.com/prometheus/alertmanager/refs/tags/''${TAG}/ui/app/elm.json"
        elm2nix convert > elm-srcs.nix
        elm2nix snapshot > registry.dat
        rm elm.json
        nixfmt elm-srcs.nix
        popd

        nix-update prometheus-alertmanager --version "''${TAG#v}"
        nix-update prometheus-alertmanager.elmUi
      '';
    });
  };

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "Alert dispatcher for the Prometheus monitoring system";
    homepage = "https://github.com/prometheus/alertmanager";
    changelog = "https://github.com/prometheus/alertmanager/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "alertmanager";
    maintainers = with lib.maintainers; [
      benley
      fpletz
      globin
      Frostman
    ];
  };
})
