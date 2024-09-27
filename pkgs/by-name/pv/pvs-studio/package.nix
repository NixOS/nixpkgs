{ lib
, stdenv
, fetchurl

, makeWrapper
, perl
, strace
}:

stdenv.mkDerivation rec {
  pname = "pvs-studio";
  version = "7.30.80678.389";

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
        x86_64-darwin = "sha256-KgYE+UFriJ/tEi6FCmj81W36fu+pSLvnCFA7hiDSU8w=";
        x86_64-linux = "sha256-5HZaROSE+PI88qYeW4li6BGH3OJ/oWymPvy4lK+XN5c=";
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
