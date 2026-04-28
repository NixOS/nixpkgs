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
      version = "2.31.10";
      hash = {
        x86_64-linux = "sha256-9ZhLKf0lNIX391BqzsqltiuMwDVJ8J7daRNowrkW4fE=";
        x86_64-darwin = "sha256-Pdd7mgWTexr2eWDMIixe//eFihUyYQszBFPScIaCciI=";
        aarch64-linux = "sha256-DcfCWUcyru3tAbNhaL5qT4okV6eu5/IJS+YhPwBAMqs=";
        aarch64-darwin = "sha256-qYFLcyTXjgWMPjmsThxDQngklT1x36MEkCTtMzn6E6k=";
      };
    };
    mainline = {
      version = "2.32.1";
      hash = {
        x86_64-linux = "sha256-IA7mz1RWnqdsS4iIa+xDTzWdcQCY6b4g1TUHnwN1aJA=";
        x86_64-darwin = "sha256-VwkbwHqrnItUrBQjratQq0No0EwWkAnOSM9rPozBJOE=";
        aarch64-linux = "sha256-VxHWXAXs724V1CyeRW7+JgIn/FEus5KwKiYg4zaOZLw=";
        aarch64-darwin = "sha256-Jn7Isn29qT8j401eAxRU0xuMfwZEejgXZjuSObmqHQg=";
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
  };

  passthru = {
    updateScript = ./update.sh;
    tests = {
      inherit (nixosTests) coder;
    };
  };
})
