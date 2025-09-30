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
      version = "2.23.4";
      hash = {
        x86_64-linux = "sha256-tpU26+3NrfOUWgd4Wav1fhTMtErh2CXt3Nr8BTIUdbc=";
        x86_64-darwin = "sha256-07pSXm++a9VWcnc4AgrR7OaaDw2ki2XMtr8PZkWW2Vw=";
        aarch64-linux = "sha256-Rm1CIVK7qPLizK+0H3Eb2qwPEj1TjHtIqdBr+Z+21eA=";
        aarch64-darwin = "sha256-H5MLnRokC5Wb3FrotprunG+kx0qwT8/Ou6ScO7N2h+E=";
      };
    };
    mainline = {
      version = "2.24.2";
      hash = {
        x86_64-linux = "sha256-Al3bvIsSnU0vdNAkZknpP/rxJIP6UGUIeIZ6kw84SuM=";
        x86_64-darwin = "sha256-0+n69BWKIgKFUCQzW4AMRW4QdRQcZkK5Ioiu4d4RvnE=";
        aarch64-linux = "sha256-2JkEO7hhLY9e22OTYLhzv+Zb0aP6PRVG8ZX5r686o0Q=";
        aarch64-darwin = "sha256-7CJQEj7VA3SwaZeimng6BPDtw14LXt7+1E7HxVs8kYM=";
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
