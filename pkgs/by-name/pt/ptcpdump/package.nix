{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  clang,
  llvm,
  bison,
  flex,
  libpcap,
  libelf,
  pkg-config,
  git,
  gnumake,
  which,
  glibc,

  # Build Options
  usePreBuildInSourceRepo ? false,
  enableStaticLinking ? false,
}:

let
  # Custom libpcap for static builds that disables libnl to avoid dependency issues
  libpcap-static = libpcap.overrideAttrs (oldAttrs: {
    configureFlags =
      (oldAttrs.configureFlags or [ ])
      ++ lib.optionals enableStaticLinking [
        "--disable-shared"
        "--enable-static"
        "--without-libnl"
        "--disable-usb"
        "--disable-netmap"
        "--disable-bluetooth"
        "--disable-dbus"
      ];
  });
in

buildGoModule rec {
  pname = "ptcpdump";
  version = "0.36.0";

  src = fetchFromGitHub {
    owner = "mozillazg";
    repo = "ptcpdump";
    rev = "v${version}";
    hash = "sha256-5bq1qmsriAjz++8Q7kTwj4VIDGce15jIN9Mh9nBDFsM=";
    fetchSubmodules = true; # Required for libpcap submodule
  };

  # Vendor folder exists in source, so no vendorHash needed
  vendorHash = null;

  passthru.updateScript = nix-update-script { };

  # Patch CGO directives and fix eBPF compilation issues
  postPatch = ''
    # Fix eBPF compilation issue: remove the specific redundant GET_CONFIG() call in handle_skb_buff function
    echo "Fixing eBPF compilation issue..."
    # Remove only the second GET_CONFIG() call that appears after line 670 in handle_skb_buff function
    sed -i '676s/^[[:space:]]*GET_CONFIG()$//' bpf/ptcpdump.c
    echo "eBPF compilation fix applied"
  ''
  + (
    if enableStaticLinking then
      ''
        echo "Configuring for static linking..."
        # Keep static flags but ensure proper library paths
        if find vendor -name "*.go" -type f -exec grep -l "cgo.*-static" {} \; 2>/dev/null | head -1; then
          echo "Found CGO static flags, updating paths..."
          # Remove hardcoded library paths
          find vendor -name "*.go" -type f -exec sed -i 's|#cgo LDFLAGS: -L/usr/local/lib -lpcap -static|#cgo LDFLAGS: -lpcap -static|g' {} \;
          echo "Static linking paths updated"
        fi
      ''
    else
      ''
        echo "Patching vendor CGO directives for dynamic linking..."

        # Find and patch any CGO directives that include -static flag
        if find vendor -name "*.go" -type f -exec grep -l "cgo.*-static" {} \; 2>/dev/null | head -1; then
          echo "Found CGO static flags, patching..."
          find vendor -name "*.go" -type f -exec sed -i 's/#cgo LDFLAGS:.*-static.*/#cgo LDFLAGS: -lpcap/g' {} \;
          echo "Patching complete"
        else
          echo "No static CGO flags found in vendor directory"
        fi
      ''
  );

  nativeBuildInputs = [
    pkg-config
    git
    gnumake
    which

    # Required for eBPF compilation
    clang
    llvm
  ]
  ++ lib.optionals (usePreBuildInSourceRepo == false) [

    # Additional dependencies for building eBPF from source
    bison
    flex
  ];

  buildInputs = [
    libelf
  ]
  ++ lib.optionals (enableStaticLinking == false) [

    # Dynamic linking requires system libpcap
    libpcap
  ]
  ++ lib.optionals (enableStaticLinking == true) [

    # Static linking requires static libraries
    glibc.static
    libpcap-static # Custom libpcap without libnl dependencies
  ];

  # Enable CGO and set linking flags based on preference
  env = {
    CGO_ENABLED = 1;
  }
  // lib.optionalAttrs (!enableStaticLinking) {

    # Dynamic linking flags
    CGO_LDFLAGS = "-lpcap";
    CGO_CFLAGS = "";
  }
  // lib.optionalAttrs enableStaticLinking {

    # Static linking flags - only libpcap since libnl is disabled
    CGO_LDFLAGS = "-lpcap -static";
    CGO_CFLAGS = "";

    # Ensure static linking for Go
    CGO_CPPFLAGS = "-static";
  };

  # Version information injected at build time
  ldflags = [
    "-s"
    "-w"
    "-X github.com/mozillazg/ptcpdump/internal.Version=${version}"
    "-X github.com/mozillazg/ptcpdump/internal.GitCommit=${src.rev}"
  ]
  ++ lib.optionals (!enableStaticLinking) [

    # Dynamic linking flags
    "-linkmode=external"
    "-extldflags=-dynamic"
  ]
  ++ lib.optionals enableStaticLinking [

    # Static linking flags
    "-linkmode=external"
    "-extldflags=-static"
  ];

  # Enable tests with exclusions for network-dependent tests
  doCheck = true;

  checkFlags = [
    # Exclude BTF package tests that require network access to download BTF specs
    "-skip=Test_loadSpec"
  ];

  # Enable installation checks
  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    # Check binary installation and functionality
    if [ -f "$out/bin/ptcpdump" ]; then
      echo "ptcpdump binary found at $out/bin/ptcpdump"

      # Test binary execution
      if $out/bin/ptcpdump --version >/dev/null 2>&1; then
        echo "ptcpdump binary executes successfully"
        $out/bin/ptcpdump --version
      else
        echo "✗ Error: ptcpdump binary exists but cannot execute"
        exit 1
      fi
    else
      echo "✗ Error: ptcpdump binary not found in $out/bin/"
      echo "Contents of $out/bin/:"
      ls -la "$out/bin/" || true
      exit 1
    fi

    runHook postInstallCheck
  '';

  preBuild = ''
    echo "ptcpdump uses ${if enableStaticLinking then "static" else "dynamic"} linking"
  ''
  + lib.optionalString (usePreBuildInSourceRepo == false) ''
    echo "Compiling eBPF bytecode from source..."

    # Update PATH for eBPF compilation
    export PATH="${clang}/bin:${llvm}/bin:$PATH"

    # Save current environment variables, beause a clean environment needed for eBPF compilation
    OLD_CC="$CC"
    OLD_CFLAGS="$NIX_CFLAGS_COMPILE"
    OLD_LDFLAGS="$NIX_LDFLAGS"

    # Use unwrapped clang and remove some environment so that eBPF can compilation
    # This avoids Nix wrapper issues with BPF target
    export CC="${clang.cc}/bin/clang"
    unset NIX_CFLAGS_COMPILE
    unset NIX_LDFLAGS
    unset NIX_CPPFLAGS
    unset NIX_STRIP
    unset NIX_HARDENING_ENABLE

    # Remove pre-compiled eBPF bytecode to force re-compiling
    echo "Removing pre-compiled eBPF bytecode..."
    find bpf -name "*.o" -type f -delete
    find bpf -name "*_bpfel.go" -type f -delete

    echo "Compiling eBPF programs..."

    cd bpf

    # Determine target architecture for eBPF compilation
    # Support both x86_64 and aarch64 architectures
    TARGET_ARCH=""
    GOARCH=""
    HEADER_DIR=""
    case "$(uname -m)" in
      x86_64)
        TARGET_ARCH="amd64"
        GOARCH="amd64"
        HEADER_DIR="amd64"
        ;;
      aarch64)
        TARGET_ARCH="arm64"
        GOARCH="arm64"
        HEADER_DIR="arm64"
        ;;
      *)
        echo "Unsupported architecture: $(uname -m)"
        exit 1
        ;;
    esac

    echo "Compiling eBPF variants for $TARGET_ARCH..."

    echo "Compiling main eBPF..."
    GOOS=linux GOARCH=$GOARCH TARGET=$TARGET_ARCH GOPACKAGE=bpf \
      go run github.com/cilium/ebpf/cmd/bpf2go \
      -cc ${clang.cc}/bin/clang \
      -no-strip \
      -target $TARGET_ARCH \
      -go-package bpf \
      -type gconfig_t \
      -type packet_event_t \
      -type exec_event_t \
      -type exit_event_t \
      -type flow_pid_key_t \
      -type process_meta_t \
      -type packet_event_meta_t \
      -type go_keylog_event_t \
      -type new_netdevice_event_t \
      -type netdevice_change_event_t \
      -type mount_event_t \
      Bpf ./ptcpdump.c \
      -- -I./headers -I./headers/$HEADER_DIR -I. -Wall

    echo "Compiling legacy eBPF..."
    GOOS=linux GOARCH=$GOARCH TARGET=$TARGET_ARCH GOPACKAGE=bpf \
      go run github.com/cilium/ebpf/cmd/bpf2go \
      -cc ${clang.cc}/bin/clang \
      -no-strip \
      -target $TARGET_ARCH \
      -go-package bpf \
      Bpf_legacy ./ptcpdump.c \
      -- -I./headers -I./headers/$HEADER_DIR -I. -Wall -DLEGACY_KERNEL

    echo "Compiling no-tracing eBPF..."
    GOOS=linux GOARCH=$GOARCH TARGET=$TARGET_ARCH GOPACKAGE=bpf \
      go run github.com/cilium/ebpf/cmd/bpf2go \
      -cc ${clang.cc}/bin/clang \
      -no-strip \
      -target $TARGET_ARCH \
      -go-package bpf \
      Bpf_no_tracing ./ptcpdump.c \
      -- -I./headers -I./headers/$HEADER_DIR -I. -Wall -DNO_TRACING

    cd ..

    echo "eBPF compilation complete"
    echo "Generated files:"
    find bpf -name "*.o" -o -name "*_bpfel.go" | sort

    # Restore original environment for Go build
    export CC="$OLD_CC"
    export NIX_CFLAGS_COMPILE="$OLD_CFLAGS"
    export NIX_LDFLAGS="$OLD_LDFLAGS"
  '';

  meta = with lib; {
    description = "Process-aware, eBPF-based tcpdump with container/pod metadata";
    longDescription = ''
      ptcpdump is a tcpdump-compatible packet analyzer powered by eBPF that automatically
      annotates packets with process, container, and pod metadata when detectable.

      Key features:

      - 🔍 Process/container/pod-aware packet capture.
      - 📦 Filter by: --pid (process), --pname (process name), --container-id (container), --pod-name (pod).
      - 🎯 tcpdump-compatible flags (-i, -w, -c, -s, -n, -C, -W, -A, and more).
      - 📜 Supports pcap-filter(7) syntax like tcpdump.
      - 🌳 tcpdump-like output + process/container/pod context.
      - 📑 Verbose mode shows detailed metadata for processes and containers/pods.
      - 💾 PcapNG with embedded metadata (Wireshark-ready).
      - 🌐 Cross-namespace capture (--netns).
      - 🚀 Kernel-space BPF filtering (low overhead, reduces CPU usage).
      - ⚡ Container runtime integration (Docker, containerd).

      Build options:
      - Set usePreBuildInSourceRepo = true to use pre-compiled eBPF bytecode
      - Set enableStaticLinking = true for static binary builds
    '';
    homepage = "https://github.com/mozillazg/ptcpdump";
    changelog = "https://github.com/mozillazg/ptcpdump/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ dvaerum ];
    platforms = platforms.linux;
    mainProgram = "ptcpdump";
  };
}
