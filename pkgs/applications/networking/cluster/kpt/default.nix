{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "kpt";
  version = "0.32.0";

  src = fetchFromGitHub {
    owner = "GoogleContainerTools";
    repo = pname;
    rev = "v${version}";
    sha256 = "1pgv15zgv30dpv148bn6x0anv9q6x78y6ldmzarb9fbjpk6j0wxl";
  };

  vendorSha256 = "0l8xdnv2m6byd5dwvs3zgcj1lsci7ax4xvx178a8a78sgkqalvmq";

  postInstall = ''
    rm $out/bin/{mdtogo,formula}
  '';

  meta = with lib; {
    description = "A toolkit to help you manage, manipulate, customize, and apply Kubernetes Resource configuration data files";
    homepage = "https://googlecontainertools.github.io/kpt/";
    license = licenses.asl20;
    maintainers = with maintainers; [ mikefaille ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
