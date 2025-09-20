{
  lib,
  fetchFromGitHub,
  buildGoModule,
  xorg,
  stdenv,
  apple-sdk_14,
}:
buildGoModule rec {
  pname = "1fps";
  version = "0.1.17";

  src = fetchFromGitHub {
    owner = "1fpsvideo";
    repo = "1fps";
    tag = "v${version}";
    hash = "sha256-8dtcW/niwmhVXB2kZdR/RjNg2ArSClL1w4nGI5rP3+Y=";
  };

  proxyVendor = true;

  vendorHash = "sha256-29x5Lh++NBAsg2O2Vr6pf9iRuVOvow2R5Iqz6twZGXA=";

  buildInputs = [
    xorg.libX11
    xorg.libXtst
    xorg.libXi
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin apple-sdk_14;

  meta = {
    description = "Encrypted Screen Sharing";
    homepage = "https://1fps.video";
    license = lib.licenses.fsl11Asl20;
    maintainers = with lib.maintainers; [ renesat ];
    mainProgram = "1fps";
  };
}
