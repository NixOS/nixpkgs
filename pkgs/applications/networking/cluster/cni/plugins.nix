{ stdenv, lib, fetchFromGitHub, go }:

stdenv.mkDerivation rec {
  name = "cni-plugins-${version}";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "containernetworking";
    repo = "plugins";
    rev = "v${version}";
    sha256 = "1saaszzxy4x3jkqd9ac6cphmzfim7x84h28c9i7az46px40blzm1";
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
