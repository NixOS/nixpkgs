{ stdenv, lib, fetchFromGitHub, go, removeReferencesTo }:

stdenv.mkDerivation rec {
  pname = "cni-plugins";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "containernetworking";
    repo = "plugins";
    rev = "v${version}";
    sha256 = "07d8knnabfjipzvcqbq7h8gd940lln934xp57nf5x31d3hpmvzws";
  };

  buildInputs = [ removeReferencesTo go ];

  buildPhase = ''
    patchShebangs build_linux.sh
    export "GOCACHE=$TMPDIR/go-cache"
    ./build_linux.sh
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv bin/* $out/bin
  '';

  preFixup = ''
    find $out/bin -type f -exec remove-references-to -t ${go} '{}' +
  '';

  meta = with lib; {
    description = "Some standard networking plugins, maintained by the CNI team";
    homepage = https://github.com/containernetworking/plugins;
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ cstrahan ];
  };
}
