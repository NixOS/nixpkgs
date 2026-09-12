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
      version = "2.36.5";
      hash = {
        x86_64-linux = "sha256-TovfhiOdKXECexfDbDyWPG2WJODxb/FXoo1gkN8/t3E=";
        aarch64-linux = "sha256-qJgULdK0Yr4cJ0aRFxcrvS1v/i69peTc6KTiTFgeupU=";
        aarch64-darwin = "sha256-qoiAdTn4NHBJYTpO6dhO4+fTSQC+0bB8KspcJ9ikokM=";
      };
    };
    mainline = {
      version = "2.37.1";
      hash = {
        x86_64-linux = "sha256-3GGT5dlUDvwpVYeyQnQ7rGXlOo3QgS+T9h1lQW0xlBM=";
        aarch64-linux = "sha256-2V1391sZql4LcqGfpuetBK5ArEitSHCmOhLLF7yqB6c=";
        aarch64-darwin = "sha256-QNcVN9m2b0PR2LiGwlt75iu4f0Fphb2fNJ/JzTnejes=";
      };
    };
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "coder";
  version = channels.${channel}.version;

  __structuredAttrs = true;

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
    platforms = lib.attrNames channels.${channel}.hash;
    mainProgram = "coder";
    maintainers = with lib.maintainers; [
      bpmct
      developmentcats
      faukah
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
