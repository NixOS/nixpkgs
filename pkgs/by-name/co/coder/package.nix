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
      version = "2.34.7";
      hash = {
        x86_64-linux = "sha256-LN0ocoosRGiXUlVSwgABvlc58f8UNVgPIPWWgVjr7NU=";
        aarch64-linux = "sha256-lwnQ6msnX/RxS6QNOgMjMepzL+QxvccusVj/GskFjlU=";
        aarch64-darwin = "sha256-NrqPfVk+76d5Li06rj31HZDpCtvRggTUseN9I7t/rAc=";
      };
    };
    mainline = {
      version = "2.35.3";
      hash = {
        x86_64-linux = "sha256-B4dODS765ZdkdmEXiTXYAA7nlZtv5tesPOV+0kONSi4=";
        aarch64-linux = "sha256-8V/NHeMf16RLQZY1/Yg36hjNeycMkjggmbT1u0RQTp0=";
        aarch64-darwin = "sha256-yo2Xh96G+FpHnAYOaVvJ2vu14zYkgEcRZIADPTOPS7I=";
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
