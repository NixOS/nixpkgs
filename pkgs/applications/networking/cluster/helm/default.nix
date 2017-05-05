{ stdenv, fetchurl, kubernetes }:
let
  arch = if stdenv.isLinux
         then "linux-amd64"
         else "darwin-amd64";
  checksum = if stdenv.isLinux
             then "17fya0d1v2w44df5n5xb99vr8qjbnbfjvicsi9p7yz4iz2mcymd6"
             else "0299ffws37d60wim8kvdp4xrvqxa93sggrprgrsiclcp8bab0dcr";
in
stdenv.mkDerivation rec {
  pname = "helm";
  version = "2.3.1";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://kubernetes-helm.storage.googleapis.com/helm-v${version}-${arch}.tar.gz";
    sha256 = "${checksum}";
  };

  preferLocalBuild = true;

  buildInputs = [ ];

  propagatedBuildInputs = [ kubernetes ];

  phases = [ "buildPhase" "installPhase" ];

  buildPhase = ''
    mkdir -p $out/bin
  '';

  installPhase = ''
    tar -xvzf $src
    cp ${arch}/helm $out/bin/${pname}
    chmod +x $out/bin/${pname}
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/kubernetes/helm;
    description = "A package manager for kubernetes";
    license = licenses.asl20;
    maintainers = [ maintainers.rlupton20 ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
