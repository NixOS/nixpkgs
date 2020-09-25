{ stdenv
, fetchurl
}:

stdenv.mkDerivation rec {
  pname = "openbazaar";
  version = "0.14.3";

  suffix = {
    i686-linux    = "linux-386";
    x86_64-darwin = "darwin-10.6-amd64";
    x86_64-linux  = "linux-amd64";
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchurl {
    url = "https://github.com/OpenBazaar/openbazaar-go/releases/download/v${version}/${pname}-go-${suffix}";
    sha256 = {
      i686-linux    = "098dgxpz9m4rfswc9yg77s3bvaifd4453s20n8kmh55g5ipgs2x1";
      x86_64-darwin = "0q989m4zj7x9d6vimmpfkla78hmx2zr7bxm9yg61ir00w60l14jx";
      x86_64-linux  = "093rwn4nfirknbxz58n16v0l0apj2h0yr63f64fqysmy78883al2";
    }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;
  dontPatchELF = true;
  preferLocalBuild = true;

  installPhase = ''
    install -D $src $out/bin/openbazaard
  '';

  postFixup = stdenv.lib.optionalString (!stdenv.isDarwin) ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      $out/bin/openbazaard
  '';

  meta = with stdenv.lib; {
    description = "Decentralized Peer to Peer Marketplace for Bitcoin - daemon";
    homepage = "https://www.openbazaar.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
    platforms = [ "i686-linux" "x86_64-darwin" "x86_64-linux" ];
  };
}
