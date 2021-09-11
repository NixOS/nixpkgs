{ lib, pkgs, buildGoModule, fetchFromGitHub }:

buildGoModule {
  pname = "cni-plugin-flannel";
  version = "unstable-2021-09-10";

  src = fetchFromGitHub {
    owner = "flannel-io";
    repo = "cni-plugin";
    rev = "8ce83510da59681da905dccb8364af9472cac341";
    sha256 = "sha256-x6F8n+IJ1pZdbDwniWWmoGKgQm235ax3mbOcbYqWLCs=";
  };

  vendorSha256 = "sha256-TLAwE3pTnJYOi1AsOQfsG6t3xLKOah/7DvYjsqyltKs=";

  postInstall = ''
    mv $out/bin/cni-plugin $out/bin/flannel
  '';

  doCheck = false;

  meta = with lib; {
    description = "flannel CNI plugin";
    homepage = "https://github.com/flannel-io/cni-plugin/";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbe ];
  };
}
