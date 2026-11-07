{
  lib,
  cutekit,
  fetchFromCodeberg,
  fetchurl,
  glibc,
  jq,
  libseccomp,
  linuxHeaders,
  llvmPackages_22,
  ninja,
  pkg-config,
  python3,
  stdenv,
  git,
  writeTextDir,
}:

let
  data = builtins.fromJSON (builtins.readFile ./sources.json);
  toolchain = llvmPackages_22.clangUseLLVM;

  # Dependencies fetched from codeberg by the `ck` wrapper in upstream.
  # Pinned to the commits recorded in the upstream `project.lock`.
  # `update.py` (via `passthru.updateScript`) regenerates `sources.json`.
  externs = lib.mapAttrs (
    _: e:
    fetchFromCodeberg {
      inherit (e)
        owner
        repo
        rev
        hash
        ;
    }
  ) data.externs;

  # cutekit invokes clang++ directly (the target sets toolchain = llvm),
  # bypassing the Nix cc-wrapper's default include wiring, so the libc++
  # and C header search paths are given explicitly, and libgcc_s is
  # linked for _Unwind_Resume.
  cxxFlagsExtra = lib.concatStringsSep " " [
    "-nostdlibinc"
    "-cxx-isystem ${llvmPackages_22.libcxx.dev}/include/c++/v1"
    "-isystem ${llvmPackages_22.libcxx.dev}/include/c++/v1"
    "-idirafter ${glibc.dev}/include"
    "-idirafter ${linuxHeaders}/include"
  ];

  ckProps = [
    "--release"
    # epoll is the async backend compatible with the seccomp sandbox.
    "--props:async=epoll"
    "--prefix=$out"
    (lib.escapeShellArg "--props:ck-cxxflags-extra=${cxxFlagsExtra}")
    "--props:ck-ldflags-extra=-lgcc_s"
  ];

  # LLVM's libunwind ships no pkg-config file, and it must be discoverable
  # via karm's `unwind` extern (looked up as `libunwind`, since nixpkgs'
  # libunwind lacks the unw_* ABI).
  libunwindPc = writeTextDir "libunwind.pc" ''
    Name: unwind
    Description: LLVM libunwind
    Version: ${llvmPackages_22.libunwind.version}
    Libs: -L${llvmPackages_22.libunwind}/lib -lunwind
    Cflags: -I${llvmPackages_22.libunwind.dev}/include
  '';

  hostPkgConfigPathVar =
    # The nix pkg-config wrapper reads PKG_CONFIG_PATH_<host-platform>.
    lib.replaceStrings [ "-" ] [ "_" ] stdenv.hostPlatform.config;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "paper-muncher";
  inherit (data) version;

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    inherit (data.src) url hash;
  };

  nativeBuildInputs = [
    cutekit
    git
    jq
    llvmPackages_22.bintools-unwrapped
    llvmPackages_22.llvm
    ninja
    pkg-config
    toolchain
  ];

  buildInputs = [
    libseccomp
    llvmPackages_22.libunwind
  ];

  postPatch =
    # cutekit normally downloads git externs into .cutekit/externs on
    # first use; provide the pinned sources as local git repos instead
    # so the build stays hermetic. The lockfile's pinned commits are
    # removed because cutekit accepts any HEAD when none are recorded.
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: src: ''
        mkdir -p .cutekit/externs/${name}
        cp -r --no-preserve=all ${src}/. .cutekit/externs/${name}/
        git -C .cutekit/externs/${name} init -q
        git -C .cutekit/externs/${name} -c user.email=nixbld@localhost -c user.name=nixbld add -A
        git -C .cutekit/externs/${name} -c user.email=nixbld@localhost -c user.name=nixbld commit -qm init
      '') externs
    )
    + ''
      jq 'del(.externs[].commit)' project.lock > project.lock.tmp
      mv project.lock.tmp project.lock

      # cutekit shells out to git for version stamping; the tarball has no .git.
      git init -q
      git config user.email "nixbld@localhost"
      git config user.name "nixbld"
      git add -A
      git commit -qm "release v${finalAttrs.version}"
    '';

  # cutekit keeps a user cache under $HOME/.cutekit.
  HOME = "/build";

  # cutekit's `package` command builds the component and installs its
  # products (bin/ + share/) under the baked-in prefix.
  buildPhase = ''
    runHook preBuild

    # cutekit resolves CC/CXX/LD/AR from the environment at build time.
    export CC="${toolchain}/bin/clang"
    export CXX="${toolchain}/bin/clang++"
    export LD="${toolchain}/bin/clang++"
    export AR="llvm-ar"

    # Expose LLVM's libunwind to cutekit's pkg-config discovery.
    export PKG_CONFIG_PATH_${hostPkgConfigPathVar}="${libunwindPc}:''${PKG_CONFIG_PATH_${hostPkgConfigPathVar}:-}"

    python3 -m cutekit package \
      ${lib.concatStringsSep " \\\n      " ckProps} \
      --sysroot="$TMPDIR/pkgroot" \
      paper-muncher

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    # The prefix is the eventual store path, which does not exist in the
    # sandbox; cutekit therefore stages products under the sysroot.
    mkdir -p "$out"
    cp -a "$TMPDIR"/pkgroot/nix/store/*/* "$out/"
    runHook postInstall
  '';

  passthru = {
    # Rewrites sources.json from the upstream project.lock of the given
    # version, keeping the derivation reviewable and nixpkgs-update
    # friendly.
    updateScript = [
      python3
      ./update.py
    ];
  };

  meta = {
    description = "Convert web pages into documents (HTML to PDF)";
    longDescription = ''
      Paper Muncher munches the web into crisp documents. It converts
      HTML, XHTML, SVG and Markdown into PDFs or images, aiming to be a
      drop-in replacement for wkhtmltopdf with faster rendering.
    '';
    homepage = "https://github.com/odoo/paper-muncher";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ yajo ];
    mainProgram = "paper-muncher";
    platforms = lib.platforms.linux;
  };
})
