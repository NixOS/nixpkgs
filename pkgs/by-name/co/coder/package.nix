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
      version = "2.23.2";
      hash = {
        x86_64-linux = "sha256-nFb4G4PQdrxwXHpialI0g3CszOdNt8xnSEZCAsFADAo=";
        x86_64-darwin = "sha256-XHivHFYxTmjR+vkkR4632ZjKqKVVb6MwSSPy0rzuLLo=";
        aarch64-linux = "sha256-DNuEeiTkGlDyOrFMuApSASs51bRYleoPQN9eMyY7c78=";
        aarch64-darwin = "sha256-A1sF3RFAQrkPU8GMOXmpzzY3CXjKwOeA6f/dZtuetZc=";
      };
    };
    mainline = {
      version = "2.24.1";
      hash = {
        x86_64-linux = "sha256-gqQlyA1LtWYpeBHupbFTFLD0KmF1P61JgrokCtqTDiI=";
        x86_64-darwin = "sha256-iiCMCs7Det/ebTRo69FDqUW76cHnzgtl0gxRfAYMnho=";
        aarch64-linux = "sha256-Qxc+GQ2xmKkgJkoMi4gtauTen1wvU5UD/faY13xnuHI=";
        aarch64-darwin = "sha256-0wRRpLhqosd4n0JhFe4/4/odUTMGwf74bYFBJ6rlTw4=";
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
