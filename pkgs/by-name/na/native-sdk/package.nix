{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "native-sdk";
  version = "0.9.5";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "vercel-labs";
    repo = "native";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-N2HIkXvCtmju6ELTB/toiC0daMP5CS/YVrGRqQpBr4M=";
  };

  installPhase = ''
    mkdir -p $out
    cp -r $src/* $out/
  '';

  meta = {
    description = "Toolkit for building native desktop apps";
    homepage = "https://native-sdk.dev";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.ElSebas41 ];
  };
})
