{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "azure-storage-azcopy";
  version = "10.28.0";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-storage-azcopy";
    tag = "v${version}";
    hash = "sha256-dRS96M4KMEQaKYVA0fNgmmfH2JYVFbEjH8C3xA9knes=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-TwzcjhL8STH8tASTp2kQjn6bYyn/Ab+EJwvIGOBT+1A=";

  doCheck = false;

  postInstall = ''
    ln -rs "$out/bin/azure-storage-azcopy" "$out/bin/azcopy"
  '';

  meta = with lib; {
    description = "New Azure Storage data transfer utility - AzCopy v10";
    homepage = "https://github.com/Azure/azure-storage-azcopy";
    changelog = "https://github.com/Azure/azure-storage-azcopy/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ kashw2 ];
  };
}
