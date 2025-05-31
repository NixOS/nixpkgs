{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "azure-storage-azcopy";
  version = "10.29.2";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-storage-azcopy";
    tag = "v${version}";
    hash = "sha256-wLErYkiN5V6aZx6Vztr3Gk5XB+aOo9de5QjEbwDLBXg=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-Aq38kpgQ1NQQVkF0hjMLzvK8HvxfzYARbeWmsc54Ldg=";

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
