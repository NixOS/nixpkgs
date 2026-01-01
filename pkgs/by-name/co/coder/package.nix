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
<<<<<<< HEAD
      version = "2.28.6";
      hash = {
        x86_64-linux = "sha256-OBnEOR6uNCzfsnWIQupSN9JMykNbrojrkb5lcPXL1W8=";
        x86_64-darwin = "sha256-ixI5BPxq7spPk1Un6eYVke+IkhqoIxTqDTXo5FehaEk=";
        aarch64-linux = "sha256-w+5PMff13nUp7jAYGSQlozShWqjsF+NLKQiquxD07wc=";
        aarch64-darwin = "sha256-nrx0Z1NdzkeQbeWzwOhpATIYnCCucG5lKRoUaRVjiQE=";
      };
    };
    mainline = {
      version = "2.29.1";
      hash = {
        x86_64-linux = "sha256-LxYADRdkiIsvHBaMy+MtJuUo8p5MLDKDL6pMtHaqokw=";
        x86_64-darwin = "sha256-OwZpCTjEVzTu4M9jf0vOuTuiyn66qRc/pEO/DLD8pvg=";
        aarch64-linux = "sha256-hNPimwzopC2Hj8i0I6KJAtvKXANACpmcN+onGvAaMvc=";
        aarch64-darwin = "sha256-AuNFtvnG40Toll/hmEXeGuV6ZcxfuVuUTFqdtTLXRn8=";
=======
      version = "2.27.3";
      hash = {
        x86_64-linux = "sha256-VGAvqipJkQM+zxBhFt57VasX/gM626xPRpV0uR7FEJA=";
        x86_64-darwin = "sha256-j41nX7CQhLsjVCBp6vaxmOcbXKXXz/iFm/TY2HXLWHA=";
        aarch64-linux = "sha256-dsjwZSoC2bQj4Zn/M7SlN83ZKMEpBjs78J4PrNGDHxE=";
        aarch64-darwin = "sha256-TLB3E1l+UNVsvgy0TVtA17lqagtBkKA4Bd2SbMjTalI=";
      };
    };
    mainline = {
      version = "2.28.0";
      hash = {
        x86_64-linux = "sha256-Z56Q5ETE3wpBJPIaZ9/qgAJ8Tj67L1ScDwuAk0Ijjkc=";
        x86_64-darwin = "sha256-tydx9Q32TvPF36+meoQ+NBQ7MXUHRPHBI4L7UNBhXQ0=";
        aarch64-linux = "sha256-x7WErWe3p6Cdr2moKG0X/DEY+dkeMhnaG2RUNWfyoQU=";
        aarch64-darwin = "sha256-jVK599hDIhWy0HOhJmPevhnZnYLylxmZ59rhrOSRGIU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
