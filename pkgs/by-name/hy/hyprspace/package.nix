{
  lib,
  buildGoModule,
  fetchFromGitHub,
  writeShellScript,
  nix-update,
  nix,
}:

buildGoModule rec {
  pname = "hyprspace";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "hyprspace";
    repo = "hyprspace";
    rev = "refs/tags/v${version}";
    hash = "sha256-zWajCfHFqPa3Z72DHcxBUq4bmcCu1lpEKUbZZewpYOE=";
  };

  env.CGO_ENABLED = "0";

  vendorHash = "sha256-LJpgGeD47Bs+Cq9Z7WWFa49F8/n3exOyxRcd6EkkL2g=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/hyprspace/hyprspace/cli.appVersion=${version}"
  ];

  preBuild = ''
    ln -s ${./config_generated.go} ./schema/config_generated.go
  '';

  passthru.updateScript = writeShellScript "update" ''
    ${lib.getExe nix-update} hyprspace
    nix () {
      ${lib.getExe nix} --extra-experimental-features 'flakes nix-command' "$@"
    }
    cat "$(
      nix build --print-out-paths --no-link \
      "github:hyprspace/hyprspace?ref=refs/tags/v$(
        nix eval .#hyprspace.version --raw
       )#vendor"
      )/schema/config_generated.go" \
    > pkgs/by-name/hy/hyprspace/config_generated.go
  '';

  meta = {
    description = "Lightweight VPN Built on top of Libp2p for Truly Distributed Networks";
    homepage = "https://github.com/hyprspace/hyprspace";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      gerg-l
      max
    ];
    platforms = lib.platforms.linux;
    mainProgram = "hyprspace";
  };
}
