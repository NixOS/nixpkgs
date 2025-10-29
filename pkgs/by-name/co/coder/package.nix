{
  lib,
  channel ? "stable",
  fetchurl,
  installShellFiles,
  makeBinaryWrapper,
  terraform,
  stdenvNoCC,
  unzip,
  nixosTests,
}:

let
  inherit (stdenvNoCC.hostPlatform) system;

  channels = {
    stable = {
      version = "2.26.2";
      hash = {
        x86_64-linux = "sha256-bIt20dfLgKtR/pnm2ZKAdMOw5tBGSiL7VdY7n1+KtGo=";
        x86_64-darwin = "sha256-VSoNXyHXKLJTxEOCNQ04j4bk3s9zRL9ITxfO8Ow7Sw4=";
        aarch64-linux = "sha256-7J6KneDZZyXwaM0ebTmVezUFcwR9w7dxIDsp9aSuPbs=";
        aarch64-darwin = "sha256-tfECXi7deg73fyQU10a5G+XU7Ql1A/jyOlJwAAVqeA8=";
      };
    };
    mainline = {
      version = "2.27.1";
      hash = {
        x86_64-linux = "sha256-BkUC6D9Qdewj+nQo8Oi8BiJkrdSnud4bFHDbXCthKqQ=";
        x86_64-darwin = "sha256-OPL7Fb0mUhGBEjdjPOTh3W6SWqOB7JvVosft/6K0Sos=";
        aarch64-linux = "sha256-oMCR5hroO9HqygakQwxRTlrJiha2MTj+gQsY8WEVe7w=";
        aarch64-darwin = "sha256-UDOaG+cT0X6t2UX4N7Wlgok9MxLLDTDZ9eY9TMN6iT8=";
      };
    };
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "coder";
  version = channels.${channel}.version;
  src = fetchurl {
    hash = (channels.${channel}.hash).${system};

    url =
      let
        systemName =
          {
            x86_64-linux = "linux_amd64";
            aarch64-linux = "linux_arm64";
            x86_64-darwin = "darwin_amd64";
            aarch64-darwin = "darwin_arm64";
          }
          .${system};

        ext =
          {
            x86_64-linux = "tar.gz";
            aarch64-linux = "tar.gz";
            x86_64-darwin = "zip";
            aarch64-darwin = "zip";
          }
          .${system};
      in
      "https://github.com/coder/coder/releases/download/v${finalAttrs.version}/coder_${finalAttrs.version}_${systemName}.${ext}";
  };

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
    unzip
  ];

  unpackPhase = ''
    runHook preUnpack

    case $src in
        *.tar.gz) tar -xz -f "$src" ;;
        *.zip)    unzip      "$src" ;;
    esac

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    install -D -m755 coder $out/bin/coder

    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/coder \
      --prefix PATH : ${lib.makeBinPath [ terraform ]}
  '';

  # integration tests require network access
  doCheck = false;

  meta = {
    description = "Provision remote development environments via Terraform";
    homepage = "https://coder.com";
    license = lib.licenses.agpl3Only;
    mainProgram = "coder";
    maintainers = with lib.maintainers; [
      ghuntley
      kylecarbs
      urandom
    ];
  };

  passthru = {
    updateScript = ./update.sh;
    tests = {
      inherit (nixosTests) coder;
    };
  };
})
