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
  version = "7.40.101088.713";

  src =
    let
      system = stdenv.hostPlatform.system;
      selectSystem = attrs: attrs.${system} or (throw "Unsupported system: ${system}");
    in
    fetchzip {
      url = selectSystem {
        aarch64-darwin = "https://web.archive.org/web/20260131193428/https://files.pvs-studio.com/pvs-studio-${version}-macos-arm64.zip";
        x86_64-darwin = "https://web.archive.org/web/20260131193142/https://files.pvs-studio.com/pvs-studio-${version}-macos-x86_64.zip";
        x86_64-linux = "https://web.archive.org/web/20260131192910/https://files.pvs-studio.com/pvs-studio-${version}-x86_64.tgz";
      };
      hash = selectSystem {
        aarch64-darwin = "sha256-ExJldpqwD9dqGtY/QQ2i3qiNXSyR6exhYKIrwgdQrtQ=";
        x86_64-darwin = "sha256-zKwUVDoi9yWCD0gooeDslTwzQ/9N17OkMqwkAL0EQe8=";
        x86_64-linux = "sha256-c7+Zvo+cHtGtdaHi+3w7Vjluo7uQ2CfptCO8RkVm7wU=";
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
