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
      version = "2.22.1";
      hash = {
        x86_64-linux = "sha256-Jr0vv0ib8FPm4QiClXyJ8eWyF+0bdcn1BHmOb5BeGKo=";
        x86_64-darwin = "sha256-rniO5/53B47Q5lOtP3nAImQNdiaHeUNb5D1aBlVoEz0=";
        aarch64-linux = "sha256-9X5Wriyavcplf0ep7y1wvgnC9mg+3gKnzShyjC3yhp0=";
        aarch64-darwin = "sha256-y/3cA5ImlXEIBh1z0ADsCtvK2E7X6URPC1miWZpeIMY=";
      };
    };
    mainline = {
      version = "2.23.0";
      hash = {
        x86_64-linux = "sha256-/0Zy0cHocahRrLRi/+LK296gP5dZENguciX+h9ByKME=";
        x86_64-darwin = "sha256-AIC5AB0rae5CSDVeJa2urrxh+4eBUTX8fhOSYc4fX58=";
        aarch64-linux = "sha256-vUfFEpMGeXdE/h9if/8PuL2t2kWJAQd8Bg6/m3N+JD0=";
        aarch64-darwin = "sha256-aGio0fhvycape2vPYrAhniirdSbjSzbZtfFIdhl1gNk=";
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
