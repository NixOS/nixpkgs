{
  lib,
  stdenvNoCC,
  fetchurl,
  buildFHSEnv,
  python3,
  gdk-pixbuf,
  libx11,
  libxext,
  libxrender,
  libxcb,
  fontconfig,
  binutils,
  gnutar,
  zstd,
}:
let
  version = "3.0.7";
  # Fetch GPL packaging helpers with their original license rather than vendoring
  # them as Nixpkgs contributions under COPYING.
  relocateCaches = fetchurl {
    url = "https://raw.githubusercontent.com/snapetech-org/pleazyng/a8b0105b74659166ad85605cf754851c09fbfb9f/linux/packaging/flatpak/relocate-caches.py";
    sha256 = "39afab559ba590a1eea0ad59a687234483d3377fd77ecda9f007da9823179921";
  };
  rebuildPixbuf = fetchurl {
    url = "https://raw.githubusercontent.com/snapetech-org/pleazyng/a8b0105b74659166ad85605cf754851c09fbfb9f/linux/packaging/rebuild-pixbuf-cache.py";
    sha256 = "ab9ae42d2061af4f6b1dfd9aab2abd88416cefd0082a31217d0ea7e9b3251325";
  };
  webkitInstaller = fetchurl {
    url = "https://raw.githubusercontent.com/snapetech-org/pleazyng/a8b0105b74659166ad85605cf754851c09fbfb9f/linux/packaging/install-webkit-helpers.py";
    sha256 = "fc28ccb4ff06df8fd5ff4212f84d221143560b9309ad497cf47b72c366ed71ba";
  };

  sources = {
    x86_64-linux = {
      arch = "x64";
      sha256 = "fbe98082916f0131981d71e4fee4dba900a2da1b62d9f82b9a3555e1da09fde9";
    };
    aarch64-linux = {
      arch = "arm64";
      sha256 = "6d02b9fc2d7fb142093e9b5b34846674339ae068c722e51db80f65413a31643d";
    };
  };
  source =
    sources.${stdenvNoCC.hostPlatform.system}
      or (throw "Pleazyng release bundles support x86_64-linux and aarch64-linux");
  bundle = stdenvNoCC.mkDerivation {
    pname = "pleazyng-bundle";
    inherit version;
    src = fetchurl {
      url = "https://github.com/snapetech-org/pleazyng/releases/download/v3.0.7/pleazyng-linux-${source.arch}.tar.gz";
      inherit (source) sha256;
    };
    # Preserve native engines, models and providers exactly as released.
    dontUnpack = true;
    dontFixup = true;
    nativeBuildInputs = [
      python3
      gdk-pixbuf.dev
    ];
    installPhase = ''
      runHook preInstall
      mkdir -p $out/lib/pleazyng
      tar -xzf $src -C $out/lib/pleazyng
      test -x $out/lib/pleazyng/pleazyng
      test -f $out/lib/pleazyng/pleazyng.sh
      chmod +x $out/lib/pleazyng/pleazyng.sh
      LD_LIBRARY_PATH=${
        lib.makeLibraryPath [
          libx11
          libxext
          libxrender
          libxcb
          fontconfig
        ]
      } \
      python3 ${rebuildPixbuf} $out/lib/pleazyng \
        --query-tool ${gdk-pixbuf.dev}/bin/gdk-pixbuf-query-loaders
      python3 ${relocateCaches} $out/lib/pleazyng
      runHook postInstall
    '';
  };
  webkitSource = (builtins.fromJSON (builtins.readFile ./webkit-runtime.json)).${source.arch};
  webkitHelpers = stdenvNoCC.mkDerivation {
    pname = "pleazyng-webkit-helpers";
    version = webkitSource.version;
    src = fetchurl { inherit (webkitSource) url sha256; };
    dontUnpack = true;
    dontFixup = true;
    nativeBuildInputs = [
      python3
      binutils
      gnutar
      zstd
    ];
    installPhase = ''
      python3 ${webkitInstaller} --bundle ${bundle}/lib/pleazyng --deb $src \
        --arch ${source.arch} --root $out --metadata ${./webkit-runtime.json}
      # FHS merges package /lib into /usr/lib, including the exact Ubuntu
      # multiarch path compiled into this production WebKit library.
      mv $out/usr/lib $out/lib
      mv $out/usr/share $out/share
      rmdir $out/usr
    '';
  };
in
buildFHSEnv {
  pname = "pleazyng";
  inherit version;
  passthru = { inherit bundle webkitHelpers; };
  # The FHS environment keeps the published bundle and launcher together.
  # It is a compatibility environment, not a security sandbox.
  targetPkgs =
    p:
    let
      runtime = with p; [
        bash
        coreutils
        gtk3
        libsecret
        libepoxy
        alsa-lib
        libevdev
        glib
        wayland
        libglvnd
        libva
        libvdpau
        vulkan-loader
        libdrm
        mesa
        libx11
        libxcb
        libxext
        libgbm
        fontconfig
        dejavu_fonts
        shared-mime-info
        xdg-utils
        cacert
        xdg-dbus-proxy
        webkitHelpers
      ];
      closure = p.closureInfo {
        rootPaths = runtime ++ [
          bundle
          p.bubblewrap
        ];
      };
      sandboxBubblewrap = p.writeShellScriptBin "bwrap" ''
        # The Ubuntu WebKit sandbox does not know about Nix store symlinks.
        # Expose only its immutable runtime closure, read-only, while retaining
        # WebKit's namespace, seccomp and broker restrictions.
        args=(--dir /nix --dir /nix/store)
        while IFS= read -r path; do
          args+=(--ro-bind "$path" "$path")
        done < ${closure}/store-paths
        exec ${p.bubblewrap}/bin/bwrap "''${args[@]}" "$@"
      '';
    in
    runtime ++ [ sandboxBubblewrap ];
  runScript = "${bundle}/lib/pleazyng/pleazyng.sh";
  extraInstallCommands = ''
    install -Dm644 ${./org.snapetech.pleazyng.desktop} \
      $out/share/applications/org.snapetech.pleazyng.desktop
    install -Dm644 ${bundle}/lib/pleazyng/pleazyng.png \
      $out/share/icons/hicolor/512x512/apps/pleazyng.png
  '';
  meta = {
    description = "Pleazyng media client for Plex, Jellyfin and Emby";
    homepage = "https://github.com/snapetech-org/pleazyng";
    license = lib.licenses.gpl3Only;
    mainProgram = "pleazyng";
    maintainers = [ lib.maintainers.snapetech ];
    platforms = builtins.attrNames sources;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
