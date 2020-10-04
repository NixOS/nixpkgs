{ stdenv, fetchurl }:
let
  version = "0.16.0";

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
    x86_64-linux = "1i6i42hwxaczkfv8ldxn3wp6bslgwfkycvh88khfmapw2f5f9mhr";
    aarch64-linux = "1ka5vscyqxckxnhnymp06yi0r2ljw42q0g62yq7qv4safljd452p";
    x86_64-darwin = "1c50c2r2hq2fi8jcijq6vn336w96ar7b6qccv5w2240i0szsxxql";
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
