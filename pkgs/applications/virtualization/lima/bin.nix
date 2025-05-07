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
      hash = "sha256-+jg2Eo4ZkgynETu8yZCDmcVvBmW0sE8pTddqoC7ziQU=";
    };

    x86_64-darwin = rec {
      archSuffix = "Darwin-x86_64";
      url = "https://github.com/lima-vm/lima/releases/download/v${version}/lima-${version}-${archSuffix}.tar.gz";
      hash = "sha256-H6UhGWjVo/iV+i3cmjZpWsKHo/ZSa4MUfGJYLYNwVcw=";
    };

    aarch64-linux = rec {
      archSuffix = "Linux-aarch64";
      url = "https://github.com/lima-vm/lima/releases/download/v${version}/lima-${version}-${archSuffix}.tar.gz";
      hash = "sha256-H3AsafkS7Lh0okHc0D8FOHrlQI5b5QTNPehbUUOVjM8=";
    };

    x86_64-linux = rec {
      archSuffix = "Linux-x86_64";
      url = "https://github.com/lima-vm/lima/releases/download/v${version}/lima-${version}-${archSuffix}.tar.gz";
      hash = "sha256-sMQ58+tiGoyHk2g3j5jJSDf2J+sg1DUBJCcmSJxGSg4=";
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
      hash
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

  meta = {
    homepage = "https://github.com/lima-vm/lima";
    description = "Linux virtual machines (on macOS, in most cases)";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tricktron ];
    platforms = lib.platforms.unix;
  };
}
