{
  buildGoModule,
  dbmate,
  fetchFromGitHub,
  lib,
}:

let
  finalAttrs = {
    pname = "ncps";
    version = "0.3.0";

    src = fetchFromGitHub {
      owner = "kalbasit";
      repo = "ncps";
      tag = "v${finalAttrs.version}";
      hash = "sha256-mBiasGQgwP8dRQqtn7z+tLKECDd1p0JE2nvCYLru0Ts=";
    };

    ldflags = [
      "-X github.com/kalbasit/ncps/cmd.Version=v${finalAttrs.version}"
    ];

    vendorHash = "sha256-5QpzU+cy14cdR5Oi2vwA+BbMSTPMXlhyq9RpzbMsRZQ=";

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
