{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "lumen-browser";
  version = "0.9.9";

  src = fetchFromGitHub {
    owner = "network-lumen";
    repo = "browser";
    rev = "v0.9.9";
    sha256 = "sha256-soVW0Wj5Jf/GUoUc5xzGC2OROacChRMj0FR9dzqqjwk=";
  };

  installPhase = ''
    mkdir -p $out/bin
    echo "Installing lumen-browser from source..."
    # Add actual build/install steps here once source structure is verified
    touch $out/bin/lumen-browser
    chmod +x $out/bin/lumen-browser
  '';

  meta = with lib; {
    description = "Native browser for the Lumen ecosystem providing direct access to on-chain state and IPFS";
    homepage = "https://github.com/network-lumen/browser";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
