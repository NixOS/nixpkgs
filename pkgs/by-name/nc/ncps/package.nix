{
  buildGoModule,
  dbmate,
  fetchFromGitHub,
  lib,
}:

let
  finalAttrs = {
    pname = "ncps";
    version = "0.4.0";

    src = fetchFromGitHub {
      owner = "kalbasit";
      repo = "ncps";
      tag = "v${finalAttrs.version}";
      hash = "sha256-A2HLbob9MHHCUNIC1OBwyFeE6KuEIdXW75hPSZMgicI=";
    };

    ldflags = [
      "-X github.com/kalbasit/ncps/cmd.Version=v${finalAttrs.version}"
    ];

    vendorHash = "sha256-Plc1L23qOYj1evVIG+O3OxVAKVeEIA+Z6sP4Z/T1SxU=";

    doCheck = true;
    checkFlags = [ "-race" ];

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
