{ stdenvNoCC
, lib
, fetchurl
, writeScript
, installShellFiles
, qemu
, makeBinaryWrapper
, autoPatchelfHook
}:

let
<<<<<<< HEAD
  version = "0.17.2";
=======
  version = "0.15.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  dist = {
    aarch64-darwin = rec {
      archSuffix = "Darwin-arm64";
      url = "https://github.com/lima-vm/lima/releases/download/v${version}/lima-${version}-${archSuffix}.tar.gz";
<<<<<<< HEAD
      sha256 = "c7e328369e6842b15452b440daa5137e00da57ca7aa025b1cf7f80bd5c7843a9";
=======
      sha256 = "0da51d3c179e89bde404ea40be88b5c11aea8c7cf50cd030fd5b779e91462856";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };

    x86_64-darwin = rec {
      archSuffix = "Darwin-x86_64";
      url = "https://github.com/lima-vm/lima/releases/download/v${version}/lima-${version}-${archSuffix}.tar.gz";
<<<<<<< HEAD
      sha256 = "5b8954b3040b82016701091bed4ac99c668ffb8d362dc7a0fdf5cb9a6ed9ebb1";
=======
      sha256 = "c535bc21923bc290ac56fe3a9ea87e8740c7c51e030f05cc32d51e726a59673e";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };

    aarch64-linux = rec {
      archSuffix = "Linux-aarch64";
      url = "https://github.com/lima-vm/lima/releases/download/v${version}/lima-${version}-${archSuffix}.tar.gz";
<<<<<<< HEAD
      sha256 = "20df104067f255212cd6df82508961b20bf4c0a16a233a74d495a4b6ee3a62e8";
=======
      sha256 = "964c897f6dc2a6e203b0c109a7cd59102fe192837c792549b597d7ac301ecf54";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };

    x86_64-linux = rec {
      archSuffix = "Linux-x86_64";
      url = "https://github.com/lima-vm/lima/releases/download/v${version}/lima-${version}-${archSuffix}.tar.gz";
<<<<<<< HEAD
      sha256 = "a9af3aec848ed7bc490baff2f1d785334cbbc6cd94f981705cc0aeab833288b0";
=======
      sha256 = "5ec308716abe8833ce36d6e77cac44d98d7cfc8add8dbcbe053a91af01cecfa1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
  };
in
stdenvNoCC.mkDerivation {
  inherit version;
  pname = "lima";
  src = fetchurl {
    inherit (dist.${stdenvNoCC.hostPlatform.system} or
      (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}")) url sha256;
  };

  sourceRoot = ".";

  nativeBuildInputs = [ makeBinaryWrapper installShellFiles ]
    ++ lib.optionals stdenvNoCC.isLinux [ autoPatchelfHook ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r bin share $out
    chmod +x $out/bin/limactl
    wrapProgram $out/bin/limactl \
      --prefix PATH : ${lib.makeBinPath [ qemu ]}
    installShellCompletion --cmd limactl \
      --bash <($out/bin/limactl completion bash) \
      --fish <($out/bin/limactl completion fish) \
      --zsh <($out/bin/limactl completion zsh)
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    USER=nix $out/bin/limactl validate $out/share/lima/examples/default.yaml
    USER=nix $out/bin/limactl validate $out/share/lima/examples/experimental/vz.yaml
  '';

  # Stripping removes entitlements of the binary on Darwin making it non-operational.
  # Therefore, disable stripping on Darwin.
  dontStrip = stdenvNoCC.isDarwin;

  passthru.updateScript =
    let
      lima-bin = builtins.toString ./bin.nix;
    in
    writeScript "update-lima-bin.sh" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts curl jq gawk

      set -eou pipefail

      LATEST_VERSION=$(curl -H "Accept: application/vnd.github+json" -Ls https://api.github.com/repos/lima-vm/lima/releases/latest | jq -r .tag_name | cut -c 2-)
      curl -Ls -o SHA256SUMS https://github.com/lima-vm/lima/releases/download/v$LATEST_VERSION/SHA256SUMS
      AARCH64_DARWIN_SHA256=$(cat SHA256SUMS | awk '/Darwin-arm64/{print $1}')
      X86_64_DARWIN_SHA256=$(cat SHA256SUMS | awk '/Darwin-x86_64/{print $1}')
      AARCH64_LINUX_SHA256=$(cat SHA256SUMS | awk '/Linux-aarch64/{print $1}')
      X86_64_LINUX_SHA256=$(cat SHA256SUMS | awk '/Linux-x86_64/{print $1}')

      # reset version first so that all platforms are always updated and in sync
      update-source-version lima-bin 0 ${lib.fakeSha256} --file=${lima-bin} --system=aarch64-darwin
      update-source-version lima-bin $LATEST_VERSION $AARCH64_DARWIN_SHA256 --file=${lima-bin} --system=aarch64-darwin
      update-source-version lima-bin 0 ${lib.fakeSha256} --file=${lima-bin} --system=x86_64-darwin
      update-source-version lima-bin $LATEST_VERSION $X86_64_DARWIN_SHA256 --file=${lima-bin} --system=x86_64-darwin
      update-source-version lima-bin 0 ${lib.fakeSha256} --file=${lima-bin} --system=aarch64-linux
      update-source-version lima-bin $LATEST_VERSION $AARCH64_LINUX_SHA256 --file=${lima-bin} --system=aarch64-linux
      update-source-version lima-bin 0 ${lib.fakeSha256} --file=${lima-bin} --system=x86_64-linux
      update-source-version lima-bin $LATEST_VERSION $X86_64_LINUX_SHA256 --file=${lima-bin} --system=x86_64-linux
      rm SHA256SUMS
    '';

  meta = with lib; {
    homepage = "https://github.com/lima-vm/lima";
    description = "Linux virtual machines (on macOS, in most cases)";
    license = licenses.asl20;
    maintainers = with maintainers; [ tricktron ];
<<<<<<< HEAD
    platforms = platforms.linux ++ platforms.darwin;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
