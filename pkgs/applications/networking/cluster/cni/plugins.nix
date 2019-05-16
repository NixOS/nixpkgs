{ stdenv, lib, fetchFromGitHub, go, removeReferencesTo }:

stdenv.mkDerivation rec {
  name = "cni-plugins-${version}";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "containernetworking";
    repo = "plugins";
    rev = "v${version}";
    sha256 = "1kfi0iz2hs4rq3cdkw12j8d47ac4f5vrpzcwcrs2yzmh2j4n5sz5";
  };

  buildInputs = [ removeReferencesTo go ];

  buildPhase = ''
    patchShebangs build.sh
    export "GOCACHE=$TMPDIR/go-cache"
    ./build.sh
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
