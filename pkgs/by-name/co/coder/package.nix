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
      version = "2.24.3";
      hash = {
        x86_64-linux = "sha256-GGthmGRqNbjUufLQ+aPfPDfmXiA4I1942NyybIddN+I=";
        x86_64-darwin = "sha256-LPFW8uOQzX6z2ahRAjhQzQ5jI8NoK94MPEKzHptaP5k=";
        aarch64-linux = "sha256-aobcb0aYiQTFgeqe4aHN8J7saknR0BXaOQm01AnE0q0=";
        aarch64-darwin = "sha256-gj2c7eY4MQsFCWItLjkHRsezSFV83xXT2jtbyro6rvo=";
      };
    };
    mainline = {
      version = "2.25.1";
      hash = {
        x86_64-linux = "sha256-Lgh9MS4ZwUa84Q5SATs05B8dVKrvRLIELWB2Y7qdC9k=";
        x86_64-darwin = "sha256-oLhDTCw/i3++25XQgJGFPbaMeNUEMX3MQATcWk+Y6N4=";
        aarch64-linux = "sha256-1I6G/o7SR3sz+BxtA8igsRFVshiaod0mofhiR4QUG8c=";
        aarch64-darwin = "sha256-bEU82OBA8V56UFQ7IA5CN2syFdihyjw8fNyuuO/EI80=";
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
