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
      version = "2.26.1";
      hash = {
        x86_64-linux = "sha256-uW3kLQc843BtoxvsSKrmyV0P6WBANhxkQ7xD4YGmF9s=";
        x86_64-darwin = "sha256-GbVwQvJQKn4upROQoRf+1rlamfsbRSXNHjKtb1cmUME=";
        aarch64-linux = "sha256-ZN982pi8ZTFOAo3O46lsWvdTxcGuLJoFFpIfTCCKdPA=";
        aarch64-darwin = "sha256-Ff0uLwFbi3MTv+X5iA5P2ZiwFjYmQBRALCb5WZ9inZU=";
      };
    };
    mainline = {
      version = "2.27.0";
      hash = {
        x86_64-linux = "sha256-wYL4d3tkbrFmtY4phIN8lxyIybBWa3T8AQ0KhgE6m3w=";
        x86_64-darwin = "sha256-SHFm1aTxgh4sAb9dDcXsJXIGTXFn/OrvL7SJ+MudZeg=";
        aarch64-linux = "sha256-+LfYUSs5rsMFrCq9qdOLL0Mq85IBcjs9V8jIGJxXvkg=";
        aarch64-darwin = "sha256-QQIcdnHFNatjrbRqWxVtvT7KqYqwKrhjHt+yWLBYdok=";
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
