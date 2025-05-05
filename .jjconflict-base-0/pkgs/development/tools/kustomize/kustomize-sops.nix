{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kustomize-sops";
  version = "4.3.3";

  src = fetchFromGitHub {
    owner = "viaduct-ai";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-qIYV0wDzBRPt6s6d2dL4FobBSMlmVm+Z0ogig3r0Q/c=";
  };

  vendorHash = "sha256-UyDW4WgDgEygMxrxbCATxlPk9KAuc9lO/ldSFyydZUA=";

  installPhase = ''
    mkdir -p $out/lib/viaduct.ai/v1/ksops/
    mkdir -p $out/lib/viaduct.ai/v1/ksops-exec/
    mv $GOPATH/bin/kustomize-sops $out/lib/viaduct.ai/v1/ksops/ksops
    ln -s $out/lib/viaduct.ai/v1/ksops/ksops $out/lib/viaduct.ai/v1/ksops-exec/ksops-exec
  '';

  # Tests are broken in a nix environment
  doCheck = false;

  meta = with lib; {
    description = "Flexible Kustomize Plugin for SOPS Encrypted Resource";
    longDescription = ''
      KSOPS can be used to decrypt any Kubernetes resource, but is most commonly
      used to decrypt encrypted Kubernetes Secrets and ConfigMaps.
    '';
    homepage = "https://github.com/viaduct-ai/kustomize-sops";
    license = licenses.asl20;
    maintainers = with maintainers; [ starcraft66 ];
  };
}
