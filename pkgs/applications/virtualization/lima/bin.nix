{
  stdenvNoCC,
  lib,
  fetchurl,
  writeScript,
  installShellFiles,
  qemu,
  makeBinaryWrapper,
  autoPatchelfHook,
  lima,
}:

let
  version = "1.0.7";

  dist = {
    aarch64-darwin = rec {
      archSuffix = "Darwin-arm64";
      url = "https://github.com/lima-vm/lima/releases/download/v${version}/lima-${version}-${archSuffix}.tar.gz";
      sha256 = "fa3836128e19920ca7113bbcc9908399c56f0665b4b04f294dd76aa02ef38905";
    };

    x86_64-darwin = rec {
      archSuffix = "Darwin-x86_64";
      url = "https://github.com/lima-vm/lima/releases/download/v${version}/lima-${version}-${archSuffix}.tar.gz";
      sha256 = "1fa5211968d5a3f895fa2ddc9a36695ac287a3f6526b83147c62582d837055cc";
    };

    aarch64-linux = rec {
      archSuffix = "Linux-aarch64";
      url = "https://github.com/lima-vm/lima/releases/download/v${version}/lima-${version}-${archSuffix}.tar.gz";
      sha256 = "1f702c69f912ecb874a241dcd03f05387ae5408e5be504cd3de85b5143958ccf";
    };

    x86_64-linux = rec {
      archSuffix = "Linux-x86_64";
      url = "https://github.com/lima-vm/lima/releases/download/v${version}/lima-${version}-${archSuffix}.tar.gz";
      sha256 = "b0c439f3eb621a8c879368378f98c94837f627eb20d43501242726489c464a0e";
    };
  };
in
stdenvNoCC.mkDerivation {
  inherit version;
  pname = "lima";
  src = fetchurl {
    inherit
      (dist.${stdenvNoCC.hostPlatform.system}
        or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}")
      )
      url
      sha256
      ;
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    makeBinaryWrapper
    installShellFiles
  ] ++ lib.optionals stdenvNoCC.hostPlatform.isLinux [ autoPatchelfHook ];

  installPhase =
    ''
      runHook preInstall
      mkdir -p $out
      cp -r bin share $out
      chmod +x $out/bin/limactl
      wrapProgram $out/bin/limactl \
        --prefix PATH : ${lib.makeBinPath [ qemu ]}
    ''
    + lib.optionalString (stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform) ''
      # the shell completion only works with a patched $out/bin/limactl and so
      # needs to run after the autoPatchelfHook is executed in postFixup.
      doShellCompletion() {
        export LIMA_HOME="$(mktemp -d)"
        installShellCompletion --cmd limactl \
          --bash <($out/bin/limactl completion bash) \
          --fish <($out/bin/limactl completion fish) \
          --zsh <($out/bin/limactl completion zsh)
      }
      postFixupHooks+=(doShellCompletion)
    ''
    + ''
      runHook postInstall
    '';

  doInstallCheck = true;
  installCheckPhase =
    ''
      pushd $out/share/lima
    ''
    + lima.installCheckPhase
    + ''
      popd
    '';

  # Stripping removes entitlements of the binary on Darwin making it non-operational.
  # Therefore, disable stripping on Darwin.
  dontStrip = stdenvNoCC.hostPlatform.isDarwin;

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
      update-source-version lima-bin $LATEST_VERSION $AARCH64_DARWIN_SHA256 --file=${lima-bin} --ignore-same-version --system=aarch64-darwin
      update-source-version lima-bin $LATEST_VERSION $X86_64_DARWIN_SHA256 --file=${lima-bin} --ignore-same-version --system=x86_64-darwin
      update-source-version lima-bin $LATEST_VERSION $AARCH64_LINUX_SHA256 --file=${lima-bin} --ignore-same-version --system=aarch64-linux
      update-source-version lima-bin $LATEST_VERSION $X86_64_LINUX_SHA256 --file=${lima-bin} --ignore-same-version --system=x86_64-linux
      rm SHA256SUMS
    '';

  meta = with lib; {
    homepage = "https://github.com/lima-vm/lima";
    description = "Linux virtual machines (on macOS, in most cases)";
    license = licenses.asl20;
    maintainers = with maintainers; [ tricktron ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
