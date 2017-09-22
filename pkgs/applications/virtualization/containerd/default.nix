{ stdenv, lib, fetchFromGitHub, removeReferencesTo
, go, libapparmor, apparmor-parser, libseccomp }:

with lib;

stdenv.mkDerivation rec {
  name = "containerd-${version}";
  version = "0.2.9";

  src = fetchFromGitHub {
    owner = "containerd";
    repo = "containerd";
    rev = "v${version}";
    sha256 = "0rix0mv203fn3rcxmpqdpb54l1a0paqplg2xgldpd943qi1rm552";
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
