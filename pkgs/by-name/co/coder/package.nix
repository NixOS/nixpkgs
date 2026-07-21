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
      version = "2.33.11";
      hash = {
        x86_64-linux = "sha256-NY9xyLc6Pr1wWPnr4fLo6t+7B7Gin/BlTH3tdxQk30k=";
        aarch64-linux = "sha256-Wc9hhotJKcb1fdjfh9pWxVs/e4YpBua1PyAhMRJbUAY=";
        aarch64-darwin = "sha256-7A6BxOg4A3Ua5SXjnh5gtG/LE94iGuRQPe/S9UjX/oc=";
      };
    };
    mainline = {
      version = "2.34.5";
      hash = {
        x86_64-linux = "sha256-B0roCJqTu6o89nHbVA3b9eHKj/VmJ9i1j4blF1I76yU=";
        aarch64-linux = "sha256-UDyEhBAlvgSHWLPtbNXHj6X2gle1Y3fjQLSKHzwc/XI=";
        aarch64-darwin = "sha256-VhliikNdqi7AauYlKQvMroEjR3jZZnhNw0HTtJFw5zg=";
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
            aarch64-darwin = "darwin_arm64";
          }
          .${system};

        ext =
          {
            x86_64-linux = "tar.gz";
            aarch64-linux = "tar.gz";
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
      bpmct
      developmentcats
      kylecarbs
      phorcys420
    ];
  };

  passthru = {
    updateScript = ./update.sh;
    tests = {
      inherit (nixosTests) coder;
    };
  };
})
