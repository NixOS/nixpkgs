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
      version = "2.28.6";
      hash = {
        x86_64-linux = "sha256-OBnEOR6uNCzfsnWIQupSN9JMykNbrojrkb5lcPXL1W8=";
        x86_64-darwin = "sha256-ixI5BPxq7spPk1Un6eYVke+IkhqoIxTqDTXo5FehaEk=";
        aarch64-linux = "sha256-w+5PMff13nUp7jAYGSQlozShWqjsF+NLKQiquxD07wc=";
        aarch64-darwin = "sha256-nrx0Z1NdzkeQbeWzwOhpATIYnCCucG5lKRoUaRVjiQE=";
      };
    };
    mainline = {
      version = "2.29.30";
      hash = {
        x86_64-linux = "sha256-dEV5CMw0LYNKC6QfEOrbzOIeMSHSTdoaMekTXAhIzEE=";
        x86_64-darwin = "sha256-iXvAycXpiMkdDgTJu4nLEoKWSro4XrD5rBQcqvT4h9E=";
        aarch64-linux = "sha256-f01pi47SgnLhQd3Seupg5PU5I5Ht0jtxKD1oV4NKaBU=";
        aarch64-darwin = "sha256-m8S9KL9B4KtyYsinXxsO8FYQaF43oEz3jxIHo8xs50c=";
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
    knownVulnerabilities = lib.optionals (lib.versionOlder finalAttrs.version "2.29.27") [
      "CVE-2026-137547: database password exposure via API errors"
    ];
  };

  passthru = {
    updateScript = ./update.sh;
    tests = {
      inherit (nixosTests) coder;
    };
  };
})
