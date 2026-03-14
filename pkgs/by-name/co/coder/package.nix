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
      version = "2.30.3";
      hash = {
        x86_64-linux = "sha256-NQ6kAQSQAIE48tt3OfHzQ7JxtE8ALWVqsMsR4KgvLMc=";
        x86_64-darwin = "sha256-oNP8YXwD/AdUHpavq222UD4HmGchPRPtX12Cp7vgWW0=";
        aarch64-linux = "sha256-Pvg/0fPNYfyjWf+AFioh+uFMbW+RONy1uJ1smnvMo50=";
        aarch64-darwin = "sha256-h19RVUTIySu5dT1LYi7qx1shcYp9WtwUkqtgvb8jy4E=";
      };
    };
    mainline = {
      version = "2.31.3";
      hash = {
        x86_64-linux = "sha256-B4rtU5JbJVMlFkxoWCq5Zj0DVLelb51QVM10of0rXoQ=";
        x86_64-darwin = "sha256-QoByJgy1BUq7IjF/CcXMMs1GVF48vmUHrmdARYqudPY=";
        aarch64-linux = "sha256-g9JtJu2gM6MiM8f7lbnudDepG09zewJqYRzG9BYx6uc=";
        aarch64-darwin = "sha256-maSYXZla60RDbhd+WPyVwhXAEhHsAwOtlUorP+swg2I=";
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
    ];
  };

  passthru = {
    updateScript = ./update.sh;
    tests = {
      inherit (nixosTests) coder;
    };
  };
})
