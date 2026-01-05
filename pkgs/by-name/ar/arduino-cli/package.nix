{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  buildFHSEnv,
  installShellFiles,
  writableTmpDirAsHomeHook,
  go-task,
}:

let

  pkg = buildGoModule rec {
    pname = "arduino-cli";
    version = "1.3.1";

    src = fetchFromGitHub {
      owner = "arduino";
      repo = "arduino-cli";
      tag = "v${version}";
      hash = "sha256-vUa/Mgztyu5jKVIIhp+Cg79n+ulN94mlfVpxecRb6PA=";
    };

    nativeBuildInputs = [
      installShellFiles
      writableTmpDirAsHomeHook
    ];

    nativeCheckInputs = [ go-task ];

    subPackages = [ "." ];

    vendorHash = "sha256-msv+ZG6uabTtPDVcRksRd8UTSpoztMKw3YGxvhJr26w=";

    postPatch =
      let
        skipTests = [
          # tries to "go install"
          "TestDummyMonitor"
          # try to Get "https://downloads.arduino.cc/libraries/library_index.tar.bz2"
          "TestDownloadAndChecksums"
          "TestParseArgs"
          "TestParseReferenceCores"
          "TestPlatformSearch"
          "TestPlatformSearchSorting"
        ];
      in
      ''
        substituteInPlace Taskfile.yml \
          --replace-fail "go test" "go test -p $NIX_BUILD_CORES -skip '(${lib.concatStringsSep "|" skipTests})'"
      '';

    doCheck = stdenv.hostPlatform.isLinux;

    checkPhase = ''
      runHook preCheck
      task go:test
      runHook postCheck
    '';

    ldflags = [
      "-s"
      "-w"
      "-X github.com/arduino/arduino-cli/internal/version.versionString=${version}"
      "-X github.com/arduino/arduino-cli/internal/version.commit=unknown"
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ "-extldflags '-static'" ];

    postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd arduino-cli \
        --bash <($out/bin/arduino-cli completion bash) \
        --zsh <($out/bin/arduino-cli completion zsh) \
        --fish <($out/bin/arduino-cli completion fish)
    '';

    meta = {
      inherit (src.meta) homepage;
      description = "Arduino from the command line";
      mainProgram = "arduino-cli";
      changelog = "https://github.com/arduino/arduino-cli/releases/tag/${version}";
      license = with lib.licenses; [
        gpl3Only
        asl20
      ];
      maintainers = with lib.maintainers; [
        ryantm
        sfrijters
      ];
    };

  };

in
if stdenv.hostPlatform.isLinux then
  # buildFHSEnv is needed because the arduino-cli downloads compiler
  # toolchains from the internet that have their interpreters pointed at
  # /lib64/ld-linux-x86-64.so.2
  buildFHSEnv {
    inherit (pkg) pname version meta;

    runScript = "${pkg.outPath}/bin/arduino-cli";

    extraInstallCommands = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      cp -r ${pkg.outPath}/share $out/share
    '';
    passthru.pureGoPkg = pkg;

    targetPkgs = pkgs: with pkgs; [ zlib ];
  }
else
  pkg
