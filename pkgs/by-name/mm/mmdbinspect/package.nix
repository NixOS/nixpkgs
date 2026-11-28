{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "mmdbinspect";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "maxmind";
    repo = "mmdbinspect";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mDBdKZzHKJz2uhqFcK/IQSAHf1KHijsbgve8aymALIA=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-iYrI2NJohPs7s5KMvw22buaw9OchvwPLKe6Ev8ESuw8=";

  subPackages = [ "cmd/mmdbinspect" ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Look up records for one or more IPs/networks in one or more .mmdb databases";
    homepage = "https://github.com/maxmind/mmdbinspect";
    changelog = "https://github.com/maxmind/mmdbinspect/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "mmdbinspect";
  };
})
