{ stdenv, fetchurl, autoPatchelfHook, lib }:

stdenv.mkDerivation rec {
  pname = "fip-c";
  version = "0.3.2";

  fipCSrc = fetchurl {
    url = "https://github.com/flint-lang/fip/releases/download/v${version}/fip-c";
    sha256 = "587441dcba543e44ed01c3435f8b7c7f6b5e07e438a73ceab0a331e140f67faa";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  dontUnpack = true;
  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  strictDeps = true;
  __structuredAttrs = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 $fipCSrc $out/bin/fip-c
    runHook postInstall
  '';

  meta = with lib; {
    description = "C Interop Module utilizing the Flint Interop Protocol";
    homepage = "https://github.com/flint-lang/fip";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ zweiler1 ];
    mainProgram = "fip-c";
  };
}
