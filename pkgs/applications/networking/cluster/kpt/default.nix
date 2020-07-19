{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "kpt";
  version = "0.31.0";

  src = fetchFromGitHub {
    owner = "GoogleContainerTools";
    repo = pname;
    rev = "v${version}";
    sha256 = "1l5mpml6pf37b76wdq6il00k5q6rvw9ds7807m103k27p7pcqgdx";
  };

  vendorSha256 = "1yb6dwbnimqfamdg57vq68q853fq04qfnh3sfbjg82sd8pz8069g";

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
