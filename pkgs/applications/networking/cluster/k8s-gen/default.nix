{ stdenv, buildGoModule, fetchgit, lib }:

buildGoModule rec {
  pname = "k8s-gen";
  version = "20200804-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "27edf66731c4c32a2b13ed7376f75e5291665a52";

  src = fetchGit {
    url = "https://github.com/jsonnet-libs/k8s";
    inherit rev;

  };

  vendorSha256 = "1dl21vip5mwz2xrxhvwv4vq6v37bm89mi8qyhy7hqfl7ccgz7zak";

  postInstall = ''
    mv $out/bin/{k8s,k8s-gen}
  '';

  meta = with lib; {
    description = "A code generator for the Jsonnet Kubernetes library";
    homepage = "https://github.com/jsonnet-libs/k8s";
    license = licenses.asl20;
    maintainers = with maintainers; [ mikefaille ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
