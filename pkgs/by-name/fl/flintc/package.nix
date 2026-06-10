{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  lib,
}:

stdenv.mkDerivation rec {
  pname = "flintc";
  version = "0.3.5";

  flintcSrc = fetchurl {
    url = "https://github.com/flint-lang/flintc/releases/download/v${version}-core/flintc";
    sha256 = "9d6ac80c28a03caf9ce46a83601c1313b3b3adedc1e61997f30918470182a1b0";
  };

  flsSrc = fetchurl {
    url = "https://github.com/flint-lang/flintc/releases/download/v${version}-core/fls";
    sha256 = "75fcedf31ccacd26733ed5a5ae19b6ab410ce3aa256bcf79ed8678d8362897a4";
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

    install -Dm755 $flintcSrc $out/bin/flintc
    install -Dm755 $flsSrc $out/bin/fls

    runHook postInstall
  '';

  meta = with lib; {
    description = "Flint programming language compiler and language server";
    homepage = "https://github.com/flint-lang/flintc";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ zweiler1 ];
    mainProgram = "flintc";
  };
}
