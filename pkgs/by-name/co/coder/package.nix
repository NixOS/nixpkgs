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
      version = "2.36.6";
      hash = {
        x86_64-linux = "sha256-VXm0K7A+aqZGqfGQhi5lo9rfpjUylrqZVT/pW4UDKcI=";
        aarch64-linux = "sha256-jof9EX3Xb73dFr51eAOliuDPEfUnkdLul3ZdKU4Vv5w=";
        aarch64-darwin = "sha256-vaz+mpt4hNhN9Jc39wNOnh0/Q5RjenXyGKl7BgMtj10=";
      };
    };
    mainline = {
      version = "2.37.2";
      hash = {
        x86_64-linux = "sha256-gSl6eWk4vYyCAAUCvomaiiYRUDl2wPVQ37rdHMH06zY=";
        aarch64-linux = "sha256-HVWGvqcdPogWBo015gtxWnXM/iRLcJEO8UVAROtkHEQ=";
        aarch64-darwin = "sha256-INFPg6wUu4O/Cr+U9o/059bfr4g3QYZWbG17DU8KeJk=";
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
