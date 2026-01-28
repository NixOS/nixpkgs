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
      version = "2.28.7";
      hash = {
        x86_64-linux = "sha256-/FiMfYdtqmORYYxcks29jTFC4XOqLV0znKltyMHAO+I=";
        x86_64-darwin = "sha256-i12KODpSpBDuEMRK9ZpgIDpXi8pw7mFsAq4Ge5mrAvY=";
        aarch64-linux = "sha256-b/NJxdAo/HuPHsFupScNldVhzzE4k0ti1/1AdrQlQLQ=";
        aarch64-darwin = "sha256-/e/euyOg+d6l8hr0i4B5ye+Wiz+aji/mqMxRBdrVj8U=";
      };
    };
    mainline = {
      version = "2.29.2";
      hash = {
        x86_64-linux = "sha256-nAqi3UKTZ6nqzDQGAcCubmXlCo+94bgwis6a1qWhtwA=";
        x86_64-darwin = "sha256-dJdA5+cJ13CnXd+6q7EEvmApFiCkIjsh0cR8Zz+xo14=";
        aarch64-linux = "sha256-voIOAZGegjbB4PGIgjQjM6toGri5QsNK9JbFeBDcc1A=";
        aarch64-darwin = "sha256-+tUUTU9lNEeLJsjipOAsNr7ug7OvZTr+TeEs0Z1Zbgw=";
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
