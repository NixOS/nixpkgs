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
      version = "2.27.6";
      hash = {
        x86_64-linux = "sha256-dfPZpceu6gdfnAJarKl0VLI6dcoBVQ/mCP+TCzTu2RA=";
        x86_64-darwin = "sha256-NsSMJdmA+JCT+vCRKUur4PW8vPBETGEFAAWIRjI5qu0=";
        aarch64-linux = "sha256-38WnGjrDzgswGCqNUJXrlyQvKhmuCfTTRnbDK7ni4no=";
        aarch64-darwin = "sha256-EfAtIb+cwID9K4MujMAfwx8Ro+kBEN8eiHx2E46pcgo=";
      };
    };
    mainline = {
      version = "2.28.3";
      hash = {
        x86_64-linux = "sha256-Vf3X4NZm/4b7XHtZJHbZUIPyFNkoahSUyVLFADD35N0=";
        x86_64-darwin = "sha256-AZ4AfT/ZHTSoHlIQVaYV3C4YB83QL8F3x7QwT3jx3wQ=";
        aarch64-linux = "sha256-WcPqzW1RoWQYel0aN1RSzXwtoJk7V0wYG5sjAm6McGA=";
        aarch64-darwin = "sha256-X0Of71lnz8dlBNTSq2htb+ad5srIiwaY5TFSChU2ZNs=";
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
