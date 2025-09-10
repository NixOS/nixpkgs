{
  lib,
  stdenv,
  fetchzip,

  installShellFiles,
  makeWrapper,
  perl,
  strace,

  testers,
  pvs-studio,
}:

# nixpkgs-update: no auto update
stdenv.mkDerivation rec {
  pname = "pvs-studio";
  version = "7.36.91321.455";

  src =
    let
      system = stdenv.hostPlatform.system;
      selectSystem = attrs: attrs.${system} or (throw "Unsupported system: ${system}");
    in
    fetchzip {
      url = selectSystem {
        aarch64-darwin = "https://web.archive.org/web/20250411093324/https://files.pvs-studio.com/pvs-studio-${version}-macos-arm64.tgz";
        x86_64-darwin = "https://web.archive.org/web/20250411092440/https://files.pvs-studio.com/pvs-studio-${version}-macos-x86_64.tgz";
        x86_64-linux = "https://web.archive.org/web/20250411091929/https://files.pvs-studio.com/pvs-studio-${version}-x86_64.tgz";
      };
      hash = selectSystem {
        aarch64-darwin = "sha256-KEDKsWXg+CRwsEi7hNKlC3CWldBtvf9Jw79vuLMKSOE=";
        x86_64-darwin = "sha256-Esf+pohienMAkWs1q5fYZ+0RzzK/WxOGljRXYJ0AtFI=";
        x86_64-linux = "sha256-Be4IGFA+307zuMnhXBZko6T27TYeBZHX/zxaXBWVPHo=";
      };
    };

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  nativeRuntimeInputs = lib.makeBinPath (
    [
      perl
    ]
    ++ lib.optionals (lib.meta.availableOn stdenv.hostPlatform strace) [
      strace
    ]
  );

  installPhase = ''
    runHook preInstall

    install -D -m 0755 bin/* -t $out/bin
    installShellCompletion --bash etc/bash_completion.d/*

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
      "aarch64-darwin"
      "x86_64-darwin"
      "x86_64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ ];
  };
}
