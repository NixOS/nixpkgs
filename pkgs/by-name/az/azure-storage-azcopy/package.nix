{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "azure-storage-azcopy";
  version = "10.30.1";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-storage-azcopy";
    tag = "v${version}";
    hash = "sha256-lHgOQ9Ff3RSi49peDETx98QMnLrANfBvkAx8c+ubiG0=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-WTsngwFA4J1CuAePKwPew/FZNrHJ9IoDCQFv63WAlzo=";

  doCheck = false;

  postInstall = ''
    ln -rs "$out/bin/azure-storage-azcopy" "$out/bin/azcopy"
  '';

  meta = {
    description = "New Azure Storage data transfer utility - AzCopy v10";
    homepage = "https://github.com/Azure/azure-storage-azcopy";
    changelog = "https://github.com/Azure/azure-storage-azcopy/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kashw2 ];
  };
}
