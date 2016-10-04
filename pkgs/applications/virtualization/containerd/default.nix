{ stdenv, lib, fetchFromGitHub
, go, libapparmor, apparmor-parser, libseccomp }:

with lib;

stdenv.mkDerivation rec {
  name = "containerd-${version}";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "containerd";
    rev = "v${version}";
    sha256 = "0hlvbd5n4v337ywkc8mnbhp9m8lg8612krv45262n87c2ijyx09s";
  };

  buildInputs = [ go ];

  preBuild = ''
    ln -s $(pwd) vendor/src/github.com/docker/containerd
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/* $out/bin
  '';

  preFixup = ''
    # remove references to go compiler
    while read file; do
      sed -ri "s,${go},$(echo "${go}" | sed "s,$NIX_STORE/[^-]*,$NIX_STORE/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee,"),g" $file
    done < <(find $out/bin -type f 2>/dev/null)
  '';

  meta = {
    homepage = https://containerd.tools/;
    description = "A daemon to control runC";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
  };
}
