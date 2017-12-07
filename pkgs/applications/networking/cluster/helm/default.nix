{ stdenv, fetchurl, kubernetes }:
let
  arch = if stdenv.isLinux
         then "linux-amd64"
         else "darwin-amd64";
  checksum = if stdenv.isLinux
             then "1hkr5s1c72sqf156lk6gsnbfs75jnpqs42f64a7mz046c06kv98f"
             else "00xw0c66x58g915989fc72mwliysxi5glrkdafi3gcfmlhrnc68i";
  pname = "helm";
  version = "2.5.1";
in
stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://kubernetes-helm.storage.googleapis.com/helm-v${version}-${arch}.tar.gz";
    sha256 = checksum;
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
