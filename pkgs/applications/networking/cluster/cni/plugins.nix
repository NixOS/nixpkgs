{ stdenv, lib, fetchFromGitHub, go, removeReferencesTo }:

stdenv.mkDerivation rec {
  name = "cni-plugins-${version}";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "containernetworking";
    repo = "plugins";
    rev = "v${version}";
    sha256 = "1sywllwnr6lc812sgkqjdd3y10r82shl88dlnwgnbgzs738q2vp2";
  };

  buildInputs = [ removeReferencesTo go ];

  GOCACHE = "off";

  buildPhase = ''
    patchShebangs build.sh
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
