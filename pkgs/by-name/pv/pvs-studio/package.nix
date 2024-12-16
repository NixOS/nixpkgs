{
  lib,
  stdenv,
  fetchzip,

  makeWrapper,
  perl,
  strace,

  testers,
  pvs-studio,
}:

stdenv.mkDerivation rec {
  pname = "pvs-studio";
  version = "7.33.85330.89";

  src =
    let
      system = stdenv.hostPlatform.system;
      selectSystem = attrs: attrs.${system} or (throw "Unsupported system: ${system}");
    in
    fetchzip {
      url = selectSystem {
        x86_64-darwin = "https://web.archive.org/web/20241115155106/https://cdn.pvs-studio.com/pvs-studio-7.33.85330.89-macos.tgz";
        x86_64-linux = "https://web.archive.org/web/20241115155538/https://cdn.pvs-studio.com/pvs-studio-7.33.85330.89-x86_64.tgz";
      };
      hash = selectSystem {
        x86_64-darwin = "sha256-jhfW+uBexzYzzf3JVqRYqtDjE5+OoT3RcuRPJEOEs18=";
        x86_64-linux = "sha256-rJQc8B2B7J0bcEI00auwIO/4PH2YMkuzSK/OyAnhdBA=";
      };
    };

  nativeBuildInputs = [ makeWrapper ];

  nativeRuntimeInputs = lib.makeBinPath [
    perl
    strace
  ];

  installPhase = ''
    runHook preInstall

    install -D -m 0755 bin/* -t $out/bin
    install -D -m 0644 etc/bash_completion.d/* -t $out/etc/bash_completion.d

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram "$out/bin/pvs-studio-analyzer" \
      --prefix PATH ":" ${nativeRuntimeInputs}
  '';

  passthru = {
    tests.version = testers.testVersion { package = pvs-studio; };
  };

  meta = {
    description = "Static analyzer for C and C++";
    homepage = "https://pvs-studio.com/en/pvs-studio";
    license = lib.licenses.unfreeRedistributable;
    platforms = [
      "x86_64-darwin"
      "x86_64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ paveloom ];
  };
}
