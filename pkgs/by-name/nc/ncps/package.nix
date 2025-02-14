{
  buildGoModule,
  dbmate,
  fetchFromGitHub,
  lib,
}:

let
  finalAttrs = {
    pname = "ncps";
    version = "0.1.1";

    src = fetchFromGitHub {
      owner = "kalbasit";
      repo = "ncps";
      tag = "v${finalAttrs.version}";
      hash = "sha256-Vr/thppCABdZDl1LEc7l7c7Ih55U/EFwJInWSUWoLJA";
    };

    ldflags = [
      "-X github.com/kalbasit/ncps/cmd.Version=v${finalAttrs.version}"
    ];

    subPackages = [ "." ];

    vendorHash = "sha256-xPrWofNyDFrUPQ42AYDs2x2gGoQ2w3tRrMIsu3SVyHA=";
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
