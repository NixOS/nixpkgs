{
  lib,
  fetchFromGitHub,
  buildGoModule,
  xorg,
}:
buildGoModule rec {
  pname = "1fps";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "1fpsvideo";
    repo = "1fps";
    rev = "v${version}";
    hash = "sha256-EtAG0UNfHUA4SylAmRZS9Wk+GUnWECIPs/4zR9RZH8g=";
  };

  proxyVendor = true;

  vendorHash = "sha256-q32whfSiwhxkawJdX2DwxE/ozXQ1QTFaxlLxxlQw/uM=";

  buildInputs = [
    xorg.libX11
    xorg.libXtst
    xorg.libXi
  ];

  meta = {
    description = "Encrypted Screen Sharing";
    homepage = "https://1fps.video";
    license = lib.licenses.fsl11Asl20;
    maintainers = with lib.maintainers; [ renesat ];
  };
}
