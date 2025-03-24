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
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "1fpsvideo";
    repo = "1fps";
    rev = "v${version}";
    hash = "sha256-3uPGFxEWmKQxQWPmotZI29GykUGQDjtDjFPps4QMs0M=";
  };

  proxyVendor = true;

  vendorHash = "sha256-J3RGQhjpGURmXOwq19BbbNg5ERrUXHnSG5Id6gX7Nug=";

  buildInputs = [
    xorg.libX11
    xorg.libXtst
    xorg.libXi
  ] ++ lib.optional stdenv.hostPlatform.isDarwin apple-sdk_14;

  meta = {
    description = "Encrypted Screen Sharing";
    homepage = "https://1fps.video";
    license = lib.licenses.fsl11Asl20;
    maintainers = with lib.maintainers; [ renesat ];
    mainProgram = "1fps";
  };
}
