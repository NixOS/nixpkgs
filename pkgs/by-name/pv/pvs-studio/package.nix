{ lib
, stdenv
, fetchurl

, makeWrapper
, perl
, strace
}:

stdenv.mkDerivation rec {
  pname = "pvs-studio";
  version = "7.27.75620.346";

  src =
    let
      system = stdenv.hostPlatform.system;
      selectSystem = attrs:
        attrs.${system} or (throw "Unsupported system: ${system}");
    in
    fetchurl {
      url = selectSystem {
        x86_64-darwin = "https://cdn.pvs-studio.com/pvs-studio-${version}-macos.tgz";
        x86_64-linux = "https://cdn.pvs-studio.com/pvs-studio-${version}-x86_64.tgz";
      };
      hash = selectSystem {
        x86_64-darwin = "sha256-T8i+slwpOOPKCLlZ0inz3WSAQNytZrysBGv5FA0IkqE=";
        x86_64-linux = "sha256-Jno4bnrgV4VS86sd2LcPJtGn7qo80mCA1htpiuFf/eQ=";
      };
    };

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    install -D -m 0755 bin/* -t $out/bin
    install -D -m 0644 etc/bash_completion.d/* -t $out/etc/bash_completion.d

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram "$out/bin/pvs-studio-analyzer" \
      --prefix PATH ":" ${lib.makeBinPath [ perl strace ]}
  '';

  meta = with lib; {
    description = "Static analyzer for C and C++";
    homepage = "https://pvs-studio.com/en/pvs-studio";
    license = licenses.unfreeRedistributable;
    platforms = [ "x86_64-darwin" "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ paveloom ];
  };
}
