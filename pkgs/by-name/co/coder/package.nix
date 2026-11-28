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
      version = "2.38.11";
      hash = {
        x86_64-linux = "sha256-ZLcLT9GnJqx3squxcTlRrxpC0LNTimGZk+Zu236zxSw=";
        aarch64-linux = "sha256-wyQ9NhMnDg331/8FaG8ASWqv2N6TRuoUU9GEmvmYHQY=";
        aarch64-darwin = "sha256-PeayO3fgNDNh0Fv/miqFwxbtWaXRV2+Yjsr/GiTL7lA=";
      };
    };
    mainline = {
      version = "2.39.5";
      hash = {
        x86_64-linux = "sha256-vied4H/SJbisl7ayNq+1GhCMnTISLNS5dXaZMPZUZVY=";
        aarch64-linux = "sha256-oam9fyUN21SLtmO5JQ+T4W0mM1NhyPLvQ0aJaavjK5Y=";
        aarch64-darwin = "sha256-mxT/f0UqsEneDjTTgmwwHbgVYRz0oc8Ho/hWVO1OIqI=";
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
