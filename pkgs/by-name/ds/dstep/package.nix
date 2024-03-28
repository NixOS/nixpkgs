{ lib, stdenv, fetchzip }:
let
  version = "1.0.0";
  sources = {
    x86_64-linux = fetchzip {
      url =
        "https://github.com/jacob-carlborg/dstep/releases/download/v${version}/dstep-${version}-linux-x86_64.tar.xz";
      hash = "sha256-7smk97r0bszP+3AfAO1YMge11dqtIn8F6qy1X0Y7LrU=";
    };
    x86_64-darwin = fetchzip {
      url =
        "https://github.com/jacob-carlborg/dstep/releases/download/v${version}/dstep-${version}-macos.tar.xz";
      hash = "sha256-ZYFmIKYgbejU23z+0agagzNJqfS0Q3P9oe9OA75GUQk=";
    };
  };
in stdenv.mkDerivation {
  name = "dstep";

  src = sources.${stdenv.hostPlatform.system} or (throw
    "Unsupported system: ${stdenv.hostPlatform.system}");

  installPhase = ''
    install -Dm755 dstep $out/bin
  '';

  meta = with lib; {
    description =
      "A tool for converting C and Objective-C headers to D modules";
    homepage = "https://github.com/jacob-carlborg/dstep";
    license = licenses.boost;
    mainProgram = "dstep";
    maintainers = with maintainers; [ imrying ];
    platforms = builtins.attrNames sources;
  };
}
