{
  stdenvNoCC,
  lib,
  fetchurl,
  writeScript,
  installShellFiles,
  qemu,
  makeBinaryWrapper,
  autoPatchelfHook,
}:

let
  version = "0.22.0";

  dist = {
    aarch64-darwin = rec {
      archSuffix = "Darwin-arm64";
      url = "https://github.com/lima-vm/lima/releases/download/v${version}/lima-${version}-${archSuffix}.tar.gz";
      sha256 = "271e0224d3e678450424abd4e6766a14ea52b146824bf8cfac7a0f486ceb2a0c";
    };

    x86_64-darwin = rec {
      archSuffix = "Darwin-x86_64";
      url = "https://github.com/lima-vm/lima/releases/download/v${version}/lima-${version}-${archSuffix}.tar.gz";
      sha256 = "f2d331ef783e0bb00e193efc3d5c9438df5d284b1cbac771e5d239c3459b2b3d";
    };

    aarch64-linux = rec {
      archSuffix = "Linux-aarch64";
      url = "https://github.com/lima-vm/lima/releases/download/v${version}/lima-${version}-${archSuffix}.tar.gz";
      sha256 = "8c5c6dc21fae19c5645bf8db8f441aeab7fba21fbe882b2b9db58c126d07846b";
    };

    x86_64-linux = rec {
      archSuffix = "Linux-x86_64";
      url = "https://github.com/lima-vm/lima/releases/download/v${version}/lima-${version}-${archSuffix}.tar.gz";
      sha256 = "58e66114ae1e991512a86b6952ab3a1ffe0e12e08199a9a3ea13c3d2f24b307e";
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

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r bin share $out
    chmod +x $out/bin/limactl
    wrapProgram $out/bin/limactl \
      --prefix PATH : ${lib.makeBinPath [ qemu ]}

    # the shell completion only works with a patched $out/bin/limactl and so
    # needs to run after the autoPatchelfHook is executed in postFixup.
    doShellCompletion() {
      installShellCompletion --cmd limactl \
        --bash <($out/bin/limactl completion bash) \
        --fish <($out/bin/limactl completion fish) \
        --zsh <($out/bin/limactl completion zsh)
    }
    postFixupHooks+=(doShellCompletion)

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    USER=nix $out/bin/limactl validate $out/share/lima/examples/default.yaml
    USER=nix $out/bin/limactl validate $out/share/lima/examples/experimental/vz.yaml
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
