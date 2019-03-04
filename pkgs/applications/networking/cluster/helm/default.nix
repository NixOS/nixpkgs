{ stdenv, fetchurl, kubectl }:
let
  isLinux = stdenv.isLinux;
  arch = if isLinux
         then "linux-amd64"
         else "darwin-amd64";
  checksum = if isLinux
             then "156709pghjpssbr9czdvc2ncajz20lix9kn7h3g7k0js4ansdv0m"
             else "1mc1jr2b9h990h0qx7qi7hyln94n9ihz2amhgixgh4wn2nr1hqqn";
  pname = "helm";
  version = "2.13.0";
in
stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://kubernetes-helm.storage.googleapis.com/helm-v${version}-${arch}.tar.gz";
    sha256 = checksum;
  };

  preferLocalBuild = true;

  buildInputs = [ ];

  propagatedBuildInputs = [ kubectl ];

  phases = [ "buildPhase" "installPhase" ];

  buildPhase = ''
    mkdir -p $out/bin
  '';

  installPhase = ''
    tar -xvzf $src
    cp ${arch}/helm $out/bin/${pname}
    chmod +x $out/bin/${pname}
    mkdir -p $out/share/bash-completion/completions
    mkdir -p $out/share/zsh/site-functions
    $out/bin/helm completion bash > $out/share/bash-completion/completions/helm
    $out/bin/helm completion zsh > $out/share/zsh/site-functions/_helm
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/kubernetes/helm;
    description = "A package manager for kubernetes";
    license = licenses.asl20;
    maintainers = [ maintainers.rlupton20 maintainers.edude03 ];
    platforms = [ "x86_64-linux" ] ++ platforms.darwin;
  };
}
