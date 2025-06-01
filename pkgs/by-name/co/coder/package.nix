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
      version = "2.20.3";
      hash = {
        x86_64-linux = "sha256-+s/xoiN7LYIMZU8n0pT3Zx6c48t+WYbWIAG73D1MkNE=";
        x86_64-darwin = "sha256-3T/Szjcfiau5k4fixz33jQDYQj+bmWxh6lztY+S+BKg=";
        aarch64-linux = "sha256-XJt22ZbSVRKyA3+VLh+hcy3hPSPg1witUahj6cLLshg=";
        aarch64-darwin = "sha256-v6efJ41ayxe/YaaM2g0KOo+Dk4jf+xbeLuLj4o09vKY=";
      };
    };
    mainline = {
      version = "2.21.3";
      hash = {
        x86_64-linux = "sha256-n5RBXjjjUfgo1xYT1atiI3M65/kQJNHkQ8q0jPifRFg=";
        x86_64-darwin = "sha256-xajUFNvv/r0ZqT1zkCwthXFWoxnP3oqcBuSap0DJ9og=";
        aarch64-linux = "sha256-ICIwkyu4lVXlsDzd0urvdw7u98PLPClnZn27qBMz4gs=";
        aarch64-darwin = "sha256-hFu3Q2jbxAIfLbatV4lh6Rn7B5kX4QnO24meMiouAk8=";
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
