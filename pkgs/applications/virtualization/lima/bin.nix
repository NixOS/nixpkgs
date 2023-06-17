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
  version = "0.15.1";

  dist = {
    aarch64-darwin = rec {
      archSuffix = "Darwin-arm64";
      url = "https://github.com/lima-vm/lima/releases/download/v${version}/lima-${version}-${archSuffix}.tar.gz";
      sha256 = "eb5dee5f96f87c2bd8046a6e5f6acb4ffe0c07b15b2863156b1427be904a4437";
    };

    x86_64-darwin = rec {
      archSuffix = "Darwin-x86_64";
      url = "https://github.com/lima-vm/lima/releases/download/v${version}/lima-${version}-${archSuffix}.tar.gz";
      sha256 = "471f7d58080031745ac88e1560a550895b89caaee1bb66162a084a5ca7a8a563";
    };

    aarch64-linux = rec {
      archSuffix = "Linux-aarch64";
      url = "https://github.com/lima-vm/lima/releases/download/v${version}/lima-${version}-${archSuffix}.tar.gz";
      sha256 = "a7e1ce0a5ac9d5b3807dd43e491282d16aafb2f4260ae5f6fbf20737d23b928d";
    };

    x86_64-linux = rec {
      archSuffix = "Linux-x86_64";
      url = "https://github.com/lima-vm/lima/releases/download/v${version}/lima-${version}-${archSuffix}.tar.gz";
      sha256 = "bfe9e41ed7a718143cbfc7b797c764ca23297a031a2645c4f8bb4be6bf0b8388";
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
  };
}
