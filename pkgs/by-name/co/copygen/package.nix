{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "copygen";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "switchupcb";
    repo = "copygen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gdoUvTla+fRoYayUeuRha8Dkix9ACxlt0tkac0CRqwA=";
  };

  vendorHash = "sha256-dOIGGZWtr8F82YJRXibdw3MvohLFBQxD+Y4OkZIJc2s=";
  subPackages = [ "." ];
  proxyVendor = true;

  meta = {
    description = "Command-line and programmatic Go code generator that generates custom type-based code";
    homepage = "https://github.com/switchupcb/copygen";
    license = lib.licenses.agpl3Only;
    mainProgram = "copygen";
    maintainers = with lib.maintainers; [ connerohnesorge ];
  };
})
