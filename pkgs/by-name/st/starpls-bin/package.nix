{ lib, stdenv, fetchurl }:

stdenv.mkDerivation (finalAttrs: {
  pname = "starpls-bin";
  version = "0.1.14";

  src = {
    x86_64-linux = fetchurl {
      url = "https://github.com/withered-magic/starpls/releases/download/v${finalAttrs.version}/starpls-linux-amd64";
      hash = "sha256-PYU+Jv3uaJqJKw6zSNOPl+NlIQgfm38cOrRqTdNXY+8=";
    };
    aarch64-darwin = fetchurl {
      url = "https://github.com/withered-magic/starpls/releases/download/v${finalAttrs.version}/starpls-darwin-arm64";
      hash = "sha256-9d1ybebguEUJu2PvMcToQEd8M4ajRrQUvBZqS6o0sbw=";
    };
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    install -D $src $out/bin/starpls
  '';

  meta = with lib; {
    homepage = "https://github.com/withered-magic/starpls";
    description = "A language server for Starlark";
    license = licenses.asl20;
    platforms = [ "aarch64-darwin" "x86_64-linux" ];
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "starpls";
  };
})
