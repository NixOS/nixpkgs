{ stdenv, fetchurl, kubectl }:
let
  isLinux = stdenv.isLinux;
  arch = if isLinux
         then "linux-amd64"
         else "darwin-amd64";
  checksum = if isLinux
             then "0bnjpiivhsxhl45ab32vzf6crv4z8nbq5kcjkvlbcbswdbgp0pq6"
             else "0smwhj4pmd4k7csz82akbkrkb0j2jxnmb33ifhkqw7n33jhl3aqp";
  pname = "helm";
  version = "2.9.0";
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
    maintainers = [ maintainers.rlupton20 ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
