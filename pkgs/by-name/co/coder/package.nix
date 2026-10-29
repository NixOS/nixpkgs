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
      version = "2.36.7";
      hash = {
        x86_64-linux = "sha256-C98Jcx42F0on224J31NF/RqtE6OjXflZO6IRWU8v8dE=";
        aarch64-linux = "sha256-7uTyV5veoZ8X4tscOJPsrRoPQo+XTsaMuPdejnD8jAs=";
        aarch64-darwin = "sha256-7oPzD/t+PHcerLRPLkgluGTH3x+I0OThtuTax3W6mo8=";
      };
    };
    mainline = {
      version = "2.38.0";
      hash = {
        x86_64-linux = "sha256-bJAmr0XxAZBReqMX0C0H89zlDIwVRIIv1lMVlsQ47XY=";
        aarch64-linux = "sha256-poCb24pNJf8lK2dlCDA/jR2CDAEHKf+TIGnb/ULS2So=";
        aarch64-darwin = "sha256-/87O/VBeFgZ3umbI2BKWLpcAEDhPcofk3Jq13EYf0+c=";
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
