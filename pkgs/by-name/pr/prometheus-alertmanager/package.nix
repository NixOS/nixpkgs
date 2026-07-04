{
  lib,
  go,
  buildGoModule,
  callPackage,
  fetchFromGitHub,
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
  version = "0.33.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "alertmanager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VXhu50KERPb4FDdcNDMftBqZVk2ipIphhejAE1wMSOk=";
  };

  postPatch = ''
    cp -r ${elmUi}/. ui/app/dist
  '';
  vendorHash = "sha256-t5jQtccln3dfcHlnEOnLQHfjzfU9kY9Y7q+r4AigvBE=";

  subPackages = [
    "cmd/alertmanager"
    "cmd/amtool"
  ];

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
