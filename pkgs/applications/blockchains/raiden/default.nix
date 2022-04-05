{ lib
, stdenv
, fetchurl
, pkgs
, ...
}:

with lib;

let
  srcUrl = "https://github.com/raiden-network/raiden/releases/download";

  version = "3.0.1";

  builds = {
    x86_64-darwin = rec {
      name = "raiden-v${version}-macOS-x86_64";
      assets = {
        url = "${srcUrl}/v${version}/${name}.zip";
        sha256 = "sha256-ZT8wDxpbZftabvly0JdpzrRSx4B1tn6E9E2T96Y/uWw=";
      };
    };

    x86_64-linux = rec {
      name = "raiden-v${version}-linux-x86_64";
      assets = {
        url = "${srcUrl}/v${version}/${name}.tar.gz";
        sha256 = "sha256-ywbI4CgX/q3wyiseZ+2yCpiZHLamUSMNnSPRL0g0eLg=";
      };
    };
  };

in
stdenv.mkDerivation rec {
  pname = "raiden";
  inherit version;

  src = fetchurl builds."${stdenv.hostPlatform.system}".assets;

  setSourceRoot = "sourceRoot=`pwd`";

  nativeBuildInputs = []
      ++ optionals stdenv.isLinux [ pkgs.autoPatchelfHook ]
      ++ optionals stdenv.isDarwin [ pkgs.unzip ];

  buildInputs = with pkgs; [ go-ethereum solc zlib ];

  dontConfigure = true;
  dontBuild = true;
  dontPatch = true;
  dontFixup = stdenv.isDarwin;

  installPhase = ''
    install -D ${builds."${stdenv.hostPlatform.system}".name} $out/bin/raiden
  '';

  meta = {
    description = "Fast, cheap, scalable token transfers for Ethereum";
    longDescription = ''
      The Raiden Network is an off-chain scaling solution, enabling
      near-instant, low-fee and scalable payments. It's complementary to the
      Ethereum Blockchain and works with any ERC20 compatible token.
    '';
    homepage = "https://developer.raiden.network/";
    downloadPage = "https://github.com/raiden-network/raiden/releases/tag/v${version}";
    changelog = "https://github.com/raiden-network/raiden/releases/tag/v${version}";
    maintainers = with maintainers; [ anandsuresh ];
    license = licenses.mit;
    platforms = [ "x86_64-darwin" "x86_64-linux" ];
  };
}
