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
      version = "2.38.6";
      hash = {
        x86_64-linux = "sha256-nCHVQsZrUUyTXIY1RaqOg/hSreEaTPugXqo8cJoysIA=";
        aarch64-linux = "sha256-H1Fquy0FNFj14n2Bk6oTVM8I4Y/aA4doDHnBh0RDtFk=";
        aarch64-darwin = "sha256-yucvoj75a7xaFx3QJyA//YXC8S+X1Vx4NV/7Wm15fxY=";
      };
    };
    mainline = {
      version = "2.39.0";
      hash = {
        x86_64-linux = "sha256-Sb3QANrESPEQ4jueBxLNW1HKijRfnHBh1Z3Ty1JtT+U=";
        aarch64-linux = "sha256-rLeWjQlUQOykvzyCYT31/dS7zjg/3Fc3ysvpDfdBEDM=";
        aarch64-darwin = "sha256-PYFivS1JSL+181WfWefKG0sXSh2GtN0QA0y0Nu/aLAQ=";
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
