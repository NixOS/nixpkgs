{
  lib,
  stdenv,
  callPackage,
  fetchurl,
  ncurses5,
  bc,
  bubblewrap,
  autoPatchelfHook,
  python3,
  libgcc,
  glibc,
  writableTmpDirAsHomeHook,
  writeShellApplication,
  curl,
  htmlq,
  common-updater-scripts,
  zlib,
  rdma-core,
  libpsm2,
  ucx,
  numactl,
  level-zero,
  libdrm,
  elfutils,
  libxrandr,
  libxfixes,
  libxext,
  libxdamage,
  libxcomposite,
  libx11,
  libxcb,
  glib,
  nss,
  nspr,
  dbus,
  at-spi2-atk,
  cups,
  gtk3,
  pango,
  cairo,
  libgbm,
  expat,
  libxkbcommon,
  eudev,
  alsa-lib,
  bzip2,
  gdbm,
  libxcrypt-legacy,
  libuuid,
  sqlite,
  libffi,
  bash,
  # The list of components to install;
  # Either [ "all" ], [ "default" ], or a custom list of components.
  # If you want to install all default components plus an extra one, pass [ "default" <your extra components here> ]
  # Note that changing this will also change the `buildInputs` of the derivation.
  components ? [ "all" ],
}:
let
  shortName = name: builtins.elemAt (lib.splitString "." name) 3;

  mkUpdateScript =
    {
      pname,
      downloadPage,
      file,
    }:
    lib.getExe (writeShellApplication {
      name = "update-intel-oneapi";
      runtimeInputs = [
        curl
        htmlq
        common-updater-scripts
      ];
      text = ''
        download_page=${lib.escapeShellArg downloadPage}
        pname=${lib.escapeShellArg pname}
        nixpkgs="$(git rev-parse --show-toplevel)"
        file="$nixpkgs/pkgs/by-name/in/intel-oneapi-toolkit/${lib.escapeShellArg file}"

        echo 'Figuring out the download URL' >&2

        # Intel helpfully gives us a wget command to run so that we can download the toolkit installer, as part of their product page.
        # This variable will contain that command (wget https://...), we will extract the URL from it.
        wget_command="$(curl "$download_page" \
          | htmlq 'code' --text \
          | grep "wget.*$pname.*sh")"

        # _offline is optional: Intel sometimes only links the online installer, which shares the same UUID and version.
        regex="wget (https://registrationcenter-download[.]intel[.]com/akdlm/IRC_NAS/([0-9a-z-]+)/$pname.([0-9]+)[.]([0-9]+)[.]([0-9]+)[.]([0-9]+)(_offline)?[.]sh)"
        if [[ "$wget_command" =~ $regex ]]; then
            uuid="''${BASH_REMATCH[2]}"
            versionYear="''${BASH_REMATCH[3]}"
            versionMajor="''${BASH_REMATCH[4]}"
            versionMinor="''${BASH_REMATCH[5]}"
            versionRel="''${BASH_REMATCH[6]}"
        else
            echo "'$wget_command' does not match the expected format $regex" >&2
            exit 1
        fi

        # Always reconstruct to point at the offline installer
        url="https://registrationcenter-download.intel.com/akdlm/IRC_NAS/$uuid/$pname-$versionYear.$versionMajor.$versionMinor.''${versionRel}_offline.sh"

        if grep -qF "url = \"$url\"" "$file"; then
            echo "The URL is the same ($url), skipping update" >&2
            exit 0
        fi

        echo "The new download URL is $url, prefetching it to store" >&2
        hash="$(nix hash convert --hash-algo sha256 "$(nix-prefetch-url --quiet "$url")")"

        sed -i "s|versionYear = \".*\";|versionYear = \"$versionYear\";|" "$file"
        sed -i "s|versionMajor = \".*\";|versionMajor = \"$versionMajor\";|" "$file"
        sed -i "s|versionMinor = \".*\";|versionMinor = \"$versionMinor\";|" "$file"
        sed -i "s|versionRel = \".*\";|versionRel = \"$versionRel\";|" "$file"
        sed -i "s|url = \".*\";|url = \"$url\";|" "$file"
        sed -i "s|hash = \".*\";|hash = \"$hash\";|" "$file"
      '';
    });

  # Figured out by looking at autoPatchelfHook failure output
  depsByComponent = rec {
    dpcpp-cpp-compiler = [
      zlib
      level-zero
    ];
    dpcpp_dbg = [
      level-zero
      zlib
    ];
    dpcpp-ct = [ zlib ];
    mpi = [
      zlib
      rdma-core
      libpsm2
      ucx
      libuuid
      numactl
      level-zero
      libffi
    ];
    pti = [ level-zero ];
    vtune = [
      libdrm
      elfutils
      zlib
      libx11
      libxext
      libxcb
      libxcomposite
      libxdamage
      libxfixes
      libxrandr
      glib
      nss
      dbus
      at-spi2-atk
      cups
      gtk3
      pango
      cairo
      libgbm
      expat
      libxkbcommon
      eudev
      alsa-lib
      at-spi2-atk
      ncurses5
      bzip2
      libuuid
      gdbm
      libxcrypt-legacy
      sqlite
      nspr
    ];
    ifort-compiler = [ ];
    tbb = [ ];
    mkl = mpi ++ pti;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "intel-oneapi-toolkit";

  versionYear = "2026";
  versionMajor = "0";
  versionMinor = "0";
  versionRel = "198";

  version = "${finalAttrs.versionYear}.${finalAttrs.versionMajor}.${finalAttrs.versionMinor}.${finalAttrs.versionRel}";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://registrationcenter-download.intel.com/akdlm/IRC_NAS/71180075-e4e3-4c6f-bbbb-19017ed0cf7d/intel-oneapi-toolkit-2026.0.0.198_offline.sh";
    hash = "sha256-FVpSiWvSQjndxzP0h+zLKvXK2ZV+7R4r/mDOFFNpTls=";
  };

  nativeBuildInputs = [
    ncurses5
    bc
    bubblewrap
    autoPatchelfHook
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    python3
    # Required for patchShebangs to discover the correct interpreter
    bash
  ]
  ++ lib.concatMap (
    comp:
    if comp == "all" || comp == "default" then
      lib.concatLists (builtins.attrValues depsByComponent)
    else
      depsByComponent.${shortName comp} or [ ]
  ) components;

  dontUnpack = true;

  # See https://software.intel.com/content/www/us/en/develop/documentation/installation-guide-for-intel-oneapi-toolkits-linux/top/installation/install-with-command-line.html
  installPhase = ''
    runHook preInstall
    mkdir -p "$out"

    export LD_LIBRARY_PATH="${lib.makeLibraryPath [ libgcc.lib ]}"

    # The installer is an insane four-stage rube goldberg machine:
    # 1. Our $src (bash script) unpacks install.sh (bash script)
    # 2. install.sh unpacks bootstrapper (dylinked binary with hardcoded interpreter in /lib)
    # 3. bootstrapper unpacks installer (dylinked binary with hardcoded interpreter and libraries in /lib)
    # 4. installer installs the actual components we need
    #
    # While stage 1 allows to "only extract", other stages always try running the next executable down, and remove stuff if they fail.
    # I'm afraid this is the cleanest solution for now.
    mkdir -p fhs-root/{lib,lib64}
    ln -s "${glibc}/lib/"* fhs-root/lib/
    ln -s "${glibc}/lib/"* fhs-root/lib64/
    bwrap \
      --bind fhs-root / \
      --bind /nix /nix \
      --ro-bind /bin /bin \
      --dev /dev \
      --proc /proc \
      bash "$src" \
        -a \
        --silent \
        --eula accept \
        --install-dir "$out" \
        --components ${lib.concatStringsSep ":" components}

    rm -rf "$out"/logs
    rm -rf "$out"/.toolkit_linking_tool

    ln -s "$out/$versionYear.$versionMajor"/{lib,etc,bin,share,opt,include} "$out"

    runHook postInstall
  '';

  autoPatchelfIgnoreMissingDeps = [
    # Needs to be dynamically loaded as it depends on the hardware
    "libcuda.so.1"
    # All too old, not in nixpkgs anymore
    "libffi.so.6"
    "libgdbm.so.4"
    "libreadline.so.6"
    # Bundled only as unversioned .so in GTPin; the .so.14 soname isn't present
    "libopencl-clang.so.14"
    # 2026 ships libsycl.so.9; some vtune binaries still reference the old .so.8
    "libsycl.so.8"
    # GTPin internal, not present in the package
    "liboutputgenerator.so"
  ];

  passthru.updateScript = mkUpdateScript {
    inherit (finalAttrs) pname;
    file = "package.nix";
    downloadPage = "https://www.intel.com/content/www/us/en/developer/tools/oneapi/oneapi-toolkit-download.html";
  };

  passthru.stdenv = callPackage ./stdenv.nix { kit = finalAttrs.finalPackage; };

  passthru.tests = callPackage ./tests.nix { kit = finalAttrs.finalPackage; };

  meta = {
    description = "Intel oneAPI Toolkit";
    homepage = "https://www.intel.com/content/www/us/en/developer/tools/oneapi/oneapi-toolkit.html";
    license = with lib.licenses; [
      intel-eula
      issl
      asl20
    ];
    maintainers = with lib.maintainers; [
      balsoft
    ];
    platforms = [ "x86_64-linux" ];
  };
})
