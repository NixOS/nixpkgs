{ stdenv, fetchurl }:
let
  version = "0.16.2";

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
    x86_64-linux = "1jg4268vm3hv2jh4p5cnn6lc0p2sv6fg2gc88kxxbnigncdv53gz";
    aarch64-linux = "0indvix9x2f0izqz21lgahlq60lq5xj5kvn8c9dss0hqnfvfxzz2";
    x86_64-darwin = "0awhl8fkqmgzavmx7qw9w97grfqkwmjsk5nra24vdm91w8vx0m53";
  };

  doBuild = false;
  doCheck = false;

  installPhase = ''
    mkdir -p "$out/bin"
    mv octant $out/bin
  '';

  meta = with stdenv.lib; {
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
