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
      version = "2.33.10";
      hash = {
        x86_64-linux = "sha256-ncMcTpDhxTi0f66+DLWeiFQgWqLNxgN2zT3RQMY9f1A=";
        x86_64-darwin = "sha256-jwucca8lFjltuptN5Kyw0S1cnTnGXPxrC+EBqamUQsE=";
        aarch64-linux = "sha256-rGlBB9iYZTih4TYr4065jVJ/dsbryqGxPrieOgHmzz4=";
        aarch64-darwin = "sha256-xoGmZZJCpc/kmKmlfthYb71oturAtF3fIB2T+yzbqwY=";
      };
    };
    mainline = {
      version = "2.34.4";
      hash = {
        x86_64-linux = "sha256-jzdr/FTBLASlqLmR3NQ6DtFVI20A2alkaA/nkvU7NR0=";
        x86_64-darwin = "sha256-k6WpBu5Gxq3IP4npfHD/H+TWzcWK2sfMof9n6RqwHvo=";
        aarch64-linux = "sha256-f62GRzVnOF1B+acpvZVUS2Q+eDIdsM7etDo3zsoGlHQ=";
        aarch64-darwin = "sha256-GR85cyL48qRu//RbW8387eWHCih/xudyggOoRwFf5jQ=";
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
