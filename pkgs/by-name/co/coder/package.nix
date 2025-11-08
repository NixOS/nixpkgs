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
      version = "2.26.3";
      hash = {
        x86_64-linux = "sha256-CqV3fCx3TtMLFjzo0Y7/vpAgXyOLABiFyqS8N5pA6xc=";
        x86_64-darwin = "sha256-PDPU3k1Bao5ibLFx3Zjbh1xsxSpJWUOOHuRbuwMmYDg=";
        aarch64-linux = "sha256-iq9LPHK6wPSdDRQqWRPr7OfN/HoESIIkOxf9luRS9ck=";
        aarch64-darwin = "sha256-n+jUocq1MaDRe14gibeA+ujLoGcSCdKQ58wihcTmdlI=";
      };
    };
    mainline = {
      version = "2.27.3";
      hash = {
        x86_64-linux = "sha256-VGAvqipJkQM+zxBhFt57VasX/gM626xPRpV0uR7FEJA=";
        x86_64-darwin = "sha256-j41nX7CQhLsjVCBp6vaxmOcbXKXXz/iFm/TY2HXLWHA=";
        aarch64-linux = "sha256-dsjwZSoC2bQj4Zn/M7SlN83ZKMEpBjs78J4PrNGDHxE=";
        aarch64-darwin = "sha256-TLB3E1l+UNVsvgy0TVtA17lqagtBkKA4Bd2SbMjTalI=";
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
