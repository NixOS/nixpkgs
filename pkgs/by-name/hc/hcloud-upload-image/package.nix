{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

let
  version = "1.3.0";
in

buildGoModule {
  pname = "hcloud-upload-image";
  inherit version;

  src = fetchFromGitHub {
    owner = "apricote";
    repo = "hcloud-upload-image";
    tag = "v${version}";
    hash = "sha256-1u9tpzciYjB/EgBI81pg9w0kez7hHZON7+AHvfKW7k0=";
  };

  proxyVendor = true;
  vendorHash = "sha256-Xz2oOM/mhcA3OgbMaE9N6Bx3Gz1QlNVBTfGEox8Yc7A=";
  subPackages = [ "." ];

  meta = {
    description = "Quickly upload any raw disk images into your Hetzner Cloud projects";
    homepage = "https://github.com/apricote/hcloud-upload-image";
    changelog = "https://github.com/apricote/hcloud-upload-image/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ stephank ];
    mainProgram = "hcloud-upload-image";
  };
}
