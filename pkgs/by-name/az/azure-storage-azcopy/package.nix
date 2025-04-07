{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "azure-storage-azcopy";
  version = "10.28.1";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-storage-azcopy";
    tag = "v${version}";
    hash = "sha256-9TWccJYcQrl986GyLAvQPTubg7P6lT+OjdkTdjww7nU=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-Cno1H6p4qr+0CDGSd6TyCVEi+lLGoruwGVkDe8lMg08=";

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
