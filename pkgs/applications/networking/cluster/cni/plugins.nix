{ stdenv, lib, fetchFromGitHub, go }:

stdenv.mkDerivation rec {
  name = "cni-plugins-${version}";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "containernetworking";
    repo = "plugins";
    rev = "v${version}";
    sha256 = "0m885v76azs7lrk6m6n53rwh0xadwvdcr90h0l3bxpdv87sj2mnf";
  };

  buildInputs = [ go ];

  buildPhase = ''
    patchShebangs build.sh
    ./build.sh
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv bin/* $out/bin
  '';

  meta = with lib; {
    description = "Some standard networking plugins, maintained by the CNI team";
    homepage = https://github.com/containernetworking/plugins;
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ cstrahan ];
  };
}
