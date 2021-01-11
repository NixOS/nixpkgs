{ lib, stdenv, fetchurl }:
let
  version = "0.16.3";

  system = stdenv.hostPlatform.system;
  suffix = {
    x86_64-linux = "Linux-64bit";
    aarch64-linux = "Linux-arm64";
    x86_64-darwin = "macOS-64bit";
  }."${system}" or (throw "Unsupported system: ${system}");

  baseurl = "https://github.com/vmware-tanzu/octant/releases/download";
  fetchsrc = sha256: fetchurl {
    url = "${baseurl}/v${version}/octant_${version}_${suffix}.tar.gz";
    sha256 = sha256."${system}";
  };
in
stdenv.mkDerivation rec {
  pname = "octant";
  inherit version;

  src = fetchsrc {
    x86_64-linux = "1c6v7d8i494k32b0zrjn4fn1idza95r6h99c33c5za4hi7gqvy0x";
    aarch64-linux = "153jd4wsq8qc598w7y4d30dy20ljyhrl68cc3pig1p712l5258zs";
    x86_64-darwin = "0y2qjdlyvhrzwg0fmxsr3jl39kd13276a7wg0ndhdjfwxvdwpxkz";
  };

  doBuild = false;
  doCheck = false;

  installPhase = ''
    mkdir -p "$out/bin"
    mv octant $out/bin
  '';

  meta = with lib; {
    description = "Highly extensible platform for developers to better understand the complexity of Kubernetes clusters.";
    longDescription = ''
      Octant is a tool for developers to understand how applications run on a Kubernetes cluster.
      It aims to be part of the developer's toolkit for gaining insight and approaching complexity found in Kubernetes.
      Octant offers a combination of introspective tooling, cluster navigation, and object management along with a
      plugin system to further extend its capabilities.
    '';
    homepage = "https://octant.dev/";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ jk ];
  };
}
