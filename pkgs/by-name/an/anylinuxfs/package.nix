{
  lib,
  stdenv,
  buildPackages,
  buildGoModule,
  darwin,
  fetchCrate,
  fetchFromGitHub,
  gvproxy,
  pkg-config,
  pkgsLinux,
  rustPlatform,
  util-linux,
  vmnet-helper,
}:

let
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "nohajc";
    repo = "anylinuxfs";
    tag = "v${version}";
    hash = "sha256-7wDaltr6MFtuGumaz1ATGaytahDZ0UPcUJPKk+U007Q=";
  };

  # Toolchain for the pieces that run *inside* the Linux microVM.
  pkgsGuest = buildPackages.pkgsCross.aarch64-multiplatform.pkgsStatic;

  # libkrun is linked in as a Rust crate. Its `krun-init-blob` build script
  # embeds a static Linux PID 1 and normally compiles it with a Linux C
  # compiler (upstream bootstraps a Debian sysroot for that). We build it
  # ourselves and pass it in via KRUN_INIT_BINARY_PATH, like libkrun-efi does.
  krunInit = pkgsGuest.stdenv.mkDerivation {
    pname = "krun-init";
    version = "0.1.0-1.19.8";

    src = fetchCrate {
      pname = "krun-init-blob";
      version = "0.1.0-1.19.8";
      hash = "sha256-FqaHpzlU54ECcgE/XFSukSkf1zqp33xWGSiPtWrDC8M=";
    };

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild
      # `init/` is the source directory, so the binary needs another name
      $CC -O2 -static -Wall -o krun-init init/init.c init/dhcp.c
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      install -Dm755 krun-init $out/init
      runHook postInstall
    '';
  };

  # Agent that runs inside the microVM, mounts the filesystem and exports it via NFS.
  # Cross-compiled for aarch64-unknown-linux-musl (static).
  vmproxy = pkgsGuest.rustPlatform.buildRustPackage (finalAttrs: {
    pname = "anylinuxfs-vmproxy";
    inherit version src;
    sourceRoot = "${src.name}/vmproxy";

    # Vendored sources are platform-independent: fetch them with the host's
    # rustPlatform so prefetching doesn't need the cross toolchain.
    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit (finalAttrs)
        pname
        version
        src
        sourceRoot
        ;
      hash = "sha256-OpNz922Alrwd3ck/59cVdiRtvN5ToCASO1eEefPJ5K0=";
    };

    # Keep the default `freebsd` feature: upstream always builds with it and
    # the code doesn't compile without it.
    dontPatchELF = true;

    # Sets build.target and Homebrew's LLVM as linker for the musl target;
    # the cross rustPlatform already passes the right --target and linker.
    postPatch = ''
      rm .cargo/config.toml
    '';
  });

  # Static library linked into init-rootfs (Go, via cgo) to boot a VM during setup.
  vmrunner-sys = rustPlatform.buildRustPackage {
    pname = "anylinuxfs-vmrunner-sys";
    inherit version src;
    sourceRoot = "${src.name}/vmrunner-sys";

    cargoHash = "sha256-L7vYN0kK4Txysm2rRtcTgmcA5YP9U+BWPH/yZ8ExURE=";

    env.KRUN_INIT_BINARY_PATH = "${krunInit}/init";

    # It's a staticlib, so the default install hook (which copies binaries) has nothing to do.
    installPhase = ''
      runHook preInstall
      install -Dm644 target/${stdenv.hostPlatform.rust.cargoShortTarget}/$cargoBuildType/libvmrunner_sys.a -t $out/lib
      runHook postInstall
    '';
  };

  # Host helper that downloads the Alpine OCI image and prepares the VM rootfs.
  init-rootfs = buildGoModule {
    pname = "anylinuxfs-init-rootfs";
    inherit version src;
    modRoot = "init-rootfs";

    vendorHash = "sha256-mDZYCBoUceablBGtNsBM4WKXrlqRPiiVDYEpc7OS/Ek=";

    tags = [ "containers_image_openpgp" ];

    ldflags = [
      "-s"
      "-w"
    ];

    # Go rejects archives with LLVM bitcode (which Rust staticlibs carry) when
    # they come from a `#cgo LDFLAGS` directive, but trusts CGO_LDFLAGS, so
    # link libvmrunner_sys.a from there instead.
    postPatch = ''
      substituteInPlace init-rootfs/vmrunner/vmrunner.go \
        --replace-fail '#cgo LDFLAGS: ''${SRCDIR}/../../vmrunner-sys/target/libvmrunner_sys.a' ""
    '';

    env.CGO_LDFLAGS = "${vmrunner-sys}/lib/libvmrunner_sys.a";
  };

  # The guest kernel has to be built on Linux; see guest-kernel.nix.
  guestKernel = pkgsLinux.callPackage ./guest-kernel.nix { };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "anylinuxfs";
  inherit version src;
  sourceRoot = "${src.name}/anylinuxfs";

  cargoHash = "sha256-06GQ2lmBh/9GuL6U/Wz5sLOeTSlXYjxZ9oSuECw6EdU=";

  # The `freebsd` default feature stays on (the crate doesn't compile without
  # it), but the FreeBSD guest pieces aren't packaged, so default ZFS mounts
  # to the Linux VM. The config is embedded with include_str!, so patch it
  # before building.
  postPatch = ''
    # Points PKG_CONFIG/CC_LINUX at wrapper scripts that use Homebrew paths
    # and download a Debian sysroot at build time.
    rm .cargo/config.toml

    chmod u+w ../etc ../etc/anylinuxfs.toml
    substituteInPlace ../etc/anylinuxfs.toml \
      --replace-fail 'zfs_os = "FreeBSD"' 'zfs_os = "Linux"'

    # The zfs/spl modules are unpacked into the rootfs only when it is
    # (re)initialized, which happens when this compiled-in version string
    # changes. Tie it to the guest kernel, so a kernel or zfs update doesn't
    # leave modules from the old kernel behind.
    chmod u+w ../share ../share/alpine ../share/alpine/rootfs.ver
    printf '%s+%s\n' "$(cat ../share/alpine/rootfs.ver)" \
      '${builtins.substring 0 32 (baseNameOf guestKernel)}' > ../share/alpine/rootfs.ver
  '';

  nativeBuildInputs = [
    darwin.sigtool
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    util-linux # libblkid
  ];

  env.KRUN_INIT_BINARY_PATH = "${krunInit}/init";

  # anylinuxfs and init-rootfs locate their helpers relative to
  # <prefix>/libexec and <prefix>/lib, resolving symlinks of their own
  # executable, so init-rootfs has to be a real file in $out.
  postInstall = ''
    install -Dm755 ${init-rootfs}/bin/init-rootfs -t $out/libexec
    ln -s ${vmproxy}/bin/vmproxy $out/libexec/vmproxy
    ln -s ${lib.getExe' gvproxy "gvproxy"} $out/libexec/gvproxy
    ln -s ${lib.getExe vmnet-helper} $out/libexec/vmnet-helper
    ln -s ${guestKernel}/Image $out/libexec/Image
    ln -s ${guestKernel}/Image-4K $out/libexec/Image-4K

    mkdir -p $out/lib
    ln -s ${guestKernel}/modules.squashfs $out/lib/modules.squashfs

    install -Dm644 ../etc/anylinuxfs.toml -t $out/etc
  '';

  # Must run after stripping, or the signature is invalidated.
  postFixup = ''
    for bin in $out/bin/anylinuxfs $out/libexec/init-rootfs; do
      codesign --entitlements ${src}/anylinuxfs.entitlements --force -s - "$bin"
    done
  '';

  __structuredAttrs = true;

  passthru = {
    inherit
      guestKernel
      init-rootfs
      krunInit
      vmproxy
      vmrunner-sys
      ;
  };

  meta = {
    description = "Mount any Linux-supported filesystem read/write on macOS using NFS and a microVM";
    homepage = "https://github.com/nohajc/anylinuxfs";
    changelog = "https://github.com/nohajc/anylinuxfs/releases/tag/${finalAttrs.src.tag}";
    license = [ lib.licenses.gpl3Only ] ++ guestKernel.meta.license;
    mainProgram = "anylinuxfs";
    maintainers = with lib.maintainers; [ fractuscontext ];
    platforms = [ "aarch64-darwin" ];
  };
})
