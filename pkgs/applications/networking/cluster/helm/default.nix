{ stdenv, fetchurl, kubectl }:
let
  isLinux = stdenv.isLinux;
  arch = if isLinux
         then "linux-amd64"
         else "darwin-amd64";
  checksum = if isLinux
             then "1fk6w6sajdi6iphxrzi9r7xfyaf923nxcqnl01s6x3f611fjvbjn"
             else "1jzgy641hm3khj0bakfbr5wd5zl3s7w5jb622fjv2jxwmnv7dxiv";
  pname = "helm";
  version = "2.9.1";
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
    platforms = [ "x86_64-linux" ] ++ platforms.darwin;
  };
}
