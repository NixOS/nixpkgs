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
  version = "7.38.97034.608";

  src =
    let
      system = stdenv.hostPlatform.system;
      selectSystem = attrs: attrs.${system} or (throw "Unsupported system: ${system}");
    in
    fetchzip {
      url = selectSystem {
        aarch64-darwin = "https://web.archive.org/web/20251002123729/https://files.pvs-studio.com/pvs-studio-${version}-macos-arm64.zip";
        x86_64-darwin = "https://web.archive.org/web/20251002121955/https://files.pvs-studio.com/pvs-studio-${version}-macos-x86_64.zip";
        x86_64-linux = "https://web.archive.org/web/20251002124032/https://files.pvs-studio.com/pvs-studio-${version}-x86_64.tgz";
      };
      hash = selectSystem {
        aarch64-darwin = "sha256-nZwG2qFnpWnJBVmfdIqT/y3gVs66NUKy4BifFCgA3aE=";
        x86_64-darwin = "sha256-Q48i518jNQYTGGW7ihcyk7/DauHH1/fWniEvdsp7rSU=";
        x86_64-linux = "sha256-Dw9PasnbUbBsVCPZoUHHcRIBzq1XqFzThaVY6NB3qFE=";
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
    maintainers = with lib.maintainers; [ sikmir ];
  };
}
