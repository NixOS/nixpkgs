{
  buildGoModule,
  dbmate,
  fetchFromGitHub,
  lib,
}:

let
  finalAttrs = {
    pname = "ncps";
    version = "0.2.0";

    src = fetchFromGitHub {
      owner = "kalbasit";
      repo = "ncps";
      tag = "v${finalAttrs.version}";
      hash = "sha256-CjiPn5godd8lT3eE9e7MnZ0/2hOEq+CG0bpgRtLtwHo=";
    };

    ldflags = [
      "-X github.com/kalbasit/ncps/cmd.Version=v${finalAttrs.version}"
    ];

    subPackages = [ "." ];

    vendorHash = "sha256-El3yvYYnase4ztG3u7xxcKE5ARy5Lvp/FVosBwOXzbU=";
    doCheck = true;

    nativeBuildInputs = [
      dbmate # used for testing
    ];

    postInstall = ''
      mkdir -p $out/share/ncps
      cp -r db $out/share/ncps/db
    '';

    meta = {
      description = "Nix binary cache proxy service";
      homepage = "https://github.com/kalbasit/ncps";
      license = lib.licenses.mit;
      mainProgram = "ncps";
      maintainers = [ lib.maintainers.kalbasit ];
    };
  };
in
buildGoModule finalAttrs
