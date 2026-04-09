{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  installShellFiles,
  buildkit,
  cni-plugins ? null,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  extraPackages ? [ ],
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "nerdctl";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "containerd";
    repo = "nerdctl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M3np4NfzEfMt4ii7Fdbdt+y1K7lSTWrqA9Bl+zpzxog=";
  };

  vendorHash = "sha256-cnusyughQitdvYhHtuvCGS9/LdI/ku7DETBdAWttKsY=";

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
    writableTmpDirAsHomeHook
  ];

  ldflags =
    let
      t = "github.com/containerd/nerdctl/v${lib.versions.major finalAttrs.version}/pkg/version";
    in
    [
      "-s"
      "-w"
      "-X ${t}.Version=v${finalAttrs.version}"
      "-X ${t}.Revision=<unknown>"
    ];

  # testing framework which we don't need and can't be build as it is an extra go application
  excludedPackages = [ "mod/tigron" ];

  # Many checks require a containerd socket and running nerdctl after it's built
  doCheck = false;

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    cat > pkg/defaults/defaults_darwin.go <<'EOF'
    /*
       Copyright The containerd Authors.

       Licensed under the Apache License, Version 2.0 (the "License");
       you may not use this file except in compliance with the License.
       You may obtain a copy of the License at

           http://www.apache.org/licenses/LICENSE-2.0

       Unless required by applicable law or agreed to in writing, software
       distributed under the License is distributed on an "AS IS" BASIS,
       WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
       See the License for the specific language governing permissions and
       limitations under the License.
    */

    // This is a dummy file to allow usage of library functions
    // on Darwin-based systems.
    // All functions and variables are empty/no-ops

    package defaults

    import (
      "os"
      "path/filepath"

      gocni "github.com/containerd/go-cni"
    )

    const (
      AppArmorProfileName = ""
      SeccompProfileName  = ""
      Runtime             = ""
    )

    func CNIPath() string {
      return gocni.DefaultCNIDir
    }

    func CNIRuntimeDir() (string, error) {
      return "/var/run/cni", nil
    }

    func CNINetConfPath() string {
      return gocni.DefaultNetDir
    }

    func DataRoot() string {
      if home, err := os.UserHomeDir(); err == nil && home != "" {
        return filepath.Join(home, ".local", "share", "nerdctl")
      }
      return "/var/lib/nerdctl"
    }

    func CgroupManager() string {
      return ""
    }

    func CgroupnsMode() string {
      return ""
    }

    func NerdctlTOML() string {
      return "/etc/nerdctl/nerdctl.toml"
    }

    func HostsDirs() []string {
      return []string{}
    }

    func HostGatewayIP() string {
      return ""
    }

    func CDISpecDirs() []string {
      return []string{"/etc/cdi", "/var/run/cdi"}
    }
    EOF
  '';

  postInstall = ''
    wrapProgram $out/bin/nerdctl \
      --prefix PATH : "${lib.makeBinPath ([ buildkit ] ++ extraPackages)}"${lib.optionalString stdenv.hostPlatform.isLinux '' \
      --prefix CNI_PATH : "${cni-plugins}/bin"''}

    mkdir -p "$TMPDIR/nerdctl-data"
    installShellCompletion --cmd nerdctl \
      --bash <($out/bin/nerdctl --data-root "$TMPDIR/nerdctl-data" completion bash) \
      --fish <($out/bin/nerdctl --data-root "$TMPDIR/nerdctl-data" completion fish) \
      --zsh <($out/bin/nerdctl --data-root "$TMPDIR/nerdctl-data" completion zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version-regex=^v([0-9.]+)$" ];
    };
  };

  meta = {
    homepage = "https://github.com/containerd/nerdctl/";
    changelog = "https://github.com/containerd/nerdctl/releases/tag/v${finalAttrs.version}";
    description = "Docker-compatible CLI for containerd";
    mainProgram = "nerdctl";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      developer-guy
      jk
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
