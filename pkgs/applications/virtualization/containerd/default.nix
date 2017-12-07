{ stdenv, lib, fetchFromGitHub, removeReferencesTo
, go, libapparmor, apparmor-parser, libseccomp }:

with lib;

stdenv.mkDerivation rec {
  name = "containerd-${version}";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "containerd";
    rev = "v${version}";
    sha256 = "16p8kixhzdx8afpciyf3fjx43xa3qrqpx06r5aqxdrqviw851zh8";
  };

  buildInputs = [ removeReferencesTo go ];

  preBuild = ''
    ln -s $(pwd) vendor/src/github.com/containerd/containerd
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/* $out/bin
  '';

  preFixup = ''
    find $out -type f -exec remove-references-to -t ${go} '{}' +
  '';

  meta = {
    homepage = https://containerd.tools/;
    description = "A daemon to control runC";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
  };
}
