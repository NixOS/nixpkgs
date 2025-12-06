{
  stdenv,
  fetchurl,
  fvpVersion,
  fvpHash,
}:

{ version, src, ... }:

let
  # MDK SDK required by fvp plugin
  mdk-sdk = fetchurl {
    url = "https://github.com/wang-bin/mdk-sdk/releases/download/v${fvpVersion}/mdk-sdk-linux-x64.tar.xz";
    hash = fvpHash;
  };
in
stdenv.mkDerivation {
  pname = "fvp";
  inherit version src;
  inherit (src) passthru;

  postPatch = ''
    # Pre-provision the MDK SDK by extracting it directly to avoid downloading during build
    mkdir -p linux
    tar -xf ${mdk-sdk} -C linux
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r ./* $out/

    runHook postInstall
  '';
}
