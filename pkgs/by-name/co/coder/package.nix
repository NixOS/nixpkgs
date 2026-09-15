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
      version = "2.35.6";
      hash = {
        x86_64-linux = "sha256-l4a3a1iFi/HhQTzFEiPAqWnvOhrkKZzKYguZDt6pQwU=";
        aarch64-linux = "sha256-zlwfykMFvrxamPjDHJEnl9Hj8aVtQbU/rSAKJgM+I+Y=";
        aarch64-darwin = "sha256-Cl53iiUTAITpzKL01dFQ8Mmpm3fgghwrwQ5wfXTaooo=";
      };
    };
    mainline = {
      version = "2.36.3";
      hash = {
        x86_64-linux = "sha256-3iY/0vfXvfwlyFrK3AtTSeVv23HfuDyUMQN2pwWDYyM=";
        aarch64-linux = "sha256-mEBiJ6WAb48wWlkYfA7OWRSSvYAZFTLbZr5595DFoKk=";
        aarch64-darwin = "sha256-31CYBjGdlPkHcne1QPrSCaL7sZ/6DcDiHvC3boK+XS0=";
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
