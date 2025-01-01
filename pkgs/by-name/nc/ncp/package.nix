{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "ncp";
  version = "0.1.5";
  src = fetchFromGitHub {
    owner = "kha7iq";
    repo = "ncp";
    tag = "v${version}";
    hash = "sha256-3YqY7FtpwYHgZuroICrtI8tvTZCiU2xlWOFCGRgbmPo=";
  };
  vendorHash = "sha256-Q6nYI9u5Jl7rxv8b8tLVTLhbJw5GSe/Sl+QOK285E8I=";

  meta = {
    description = "Effortlessly transfer files and folders, to and from your NFS server";
    homepage = "https://github.com/kha7iq/ncp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ darwincereska ];
    mainProgram = "ncp";
  };
}
