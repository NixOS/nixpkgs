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
      version = "2.33.9";
      hash = {
        x86_64-linux = "sha256-/X1/1xlPV/86MyAXv7MJU8YtEemRNYdasBP6lH586DM=";
        x86_64-darwin = "sha256-9ns+EzDMgyo+zgfQ3867AhTQ1qENPjtHXCYWtmP00mU=";
        aarch64-linux = "sha256-4hrV9va+c3VvQXIQ2j6CGZ19ZFCFDEsHhfZu/kQfhwA=";
        aarch64-darwin = "sha256-5k15Rf09/n/eKvVD0VxDWWWgJK7U0DDNAf0p923BGLs=";
      };
    };
    mainline = {
      version = "2.34.3";
      hash = {
        x86_64-linux = "sha256-j7r5qupAsjkA11KJpdTIVtogWvSxz59nMKtTS92NMDk=";
        x86_64-darwin = "sha256-MJJK0NeXHfd/ipmPUrdhrcCOArafYH3sq+MW7GiLVnY=";
        aarch64-linux = "sha256-avDUA/3RLcoyt6QZ3CllvjNp8O65g+0CkAJjMOOVKLg=";
        aarch64-darwin = "sha256-qCHsK0zOqJO/ECb9afaEwNia9R/AJMgtRpIFUfZeY1Y=";
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
      bpmct
      developmentcats
      ghuntley
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
