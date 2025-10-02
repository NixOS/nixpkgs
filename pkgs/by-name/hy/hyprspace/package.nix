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
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "hyprspace";
    repo = "hyprspace";
    tag = "v${version}";
    hash = "sha256-Lv/Mb7vj1bUj5TajIdM6bu8299y+B3sZfE6xlA6sXcM=";
  };

  env.CGO_ENABLED = "0";

  vendorHash = "sha256-97uIl3b3hs3BCLH7UZX8NU3kLloVQOCN9ygsdxsfass=";

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
