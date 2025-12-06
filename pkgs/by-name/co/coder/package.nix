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
      version = "2.28.5";
      hash = {
        x86_64-linux = "sha256-eVMCIdXTWr3jmJYbR9ycoddqyst0immXfSSbeegFNwo=";
        x86_64-darwin = "sha256-hwLtrPY1NARgeiQzoC+LiF9ELt7pAYiNnk767M4j41s=";
        aarch64-linux = "sha256-F4WpbZ/wz/Tt1dzEFYlciPo2yPbH7nv7sJA+frIbAlA=";
        aarch64-darwin = "sha256-oIpVJ2eMo/iarM037UEaY/+C10BVOvb6P+vXlb3v6Fk=";
      };
    };
    mainline = {
      version = "2.29.0";
      hash = {
        x86_64-linux = "sha256-gDgDJMm7I11eRyitzFyJpUG2EODCuvEsmmxdSkXeYlQ=";
        x86_64-darwin = "sha256-qKgTVrmYQDfyrWQ8OD4QZ6KV8v32/aZIG9npCRUklD4=";
        aarch64-linux = "sha256-mx8vTmLXtcxTESF2LrZOaRTXu08ofOKAD6WxP3Ekcfg=";
        aarch64-darwin = "sha256-4kOoJ+Ru3RAJXD0j3GvDRcloimpHVHXv/nB/q9+y2GQ=";
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
