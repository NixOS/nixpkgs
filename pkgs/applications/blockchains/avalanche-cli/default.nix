{ stdenv, fetchurl, lib }:

let
  arch =
    if stdenv.isAarch64 then "arm64"
    else if stdenv.isx86_64 then "amd64"
    else throw "Unsupported architecture ${stdenv.hostPlatform.system}";

  plat =
    if stdenv.isDarwin then "darwin"
    else if stdenv.isLinux then "linux"
    else throw "Unsupported platform ${stdenv.system}";

  sha256 = if plat == "darwin" && arch == "amd64" then "cc2c7e63e090021a067f5b2ef6442d2cd8bb737192f12a98672834bc552d68e5"
            else if plat == "darwin" && arch == "arm64" then "de0dedee4069ddb5a796239d0ea3f0c92d8fbcb43ee5833a66c1da6fb2cb9a9a"
            else if plat == "linux" && arch == "amd64" then "3e0ec89e54837a17d8e47e3f492c57c3f6cce3ef5548afa0a5e223753fe44dfb"
            else "494db96363d35d00d147abc41dd4950469d311dec9ea10edb5671f8ae4ddb955";
in stdenv.mkDerivation rec {
  pname = "avalanche-cli";
  version = "1.2.3";

  src = fetchurl {
    url = "https://github.com/ava-labs/${pname}/releases/download/v${version}/${pname}_${version}_${plat}_${arch}.tar.gz";
    sha256 = sha256;
  };

  buildInputs = [ ];

  unpackPhase = ''
    tar -xzf $src
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp avalanche $out/bin/avalanche
  '';

  meta = with lib; {
    description = "Avalanche CLI";
    homepage = "https://github.com/ava-labs/avalanche-cli";
    platforms = [ "x86_64-darwin" "aarch64-darwin" "x86_64-linux" "aarch64-linux" ];
  };
}
