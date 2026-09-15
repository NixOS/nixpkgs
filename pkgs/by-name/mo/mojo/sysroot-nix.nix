{
  lib,
  stdenv,
  glibc,
  linuxHeaders,
  libgcc,
  zlib,
  xz,
  zstd,
  ncurses,
  libxml2,
  libffi,
  libedit,
  openssl,
  libbsd,
  libmd,
  moduleName ? "sysroot-jammy-x86_64",
}:

# Debian-like sysroot so Modular's clang (--target=x86_64-unknown-linux-gnu,
# -stdlib=libstdc++) can compile and link against nixpkgs glibc/libstdc++.
stdenv.mkDerivation {
  pname = "mojo-sysroot-nix";
  inherit (glibc) version;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  passAsFile = [
    "moduleBazel"
    "sysrootBuild"
  ];

  moduleBazel = ''
    module(name = "${moduleName}")

    bazel_dep(name = "bazel_skylib", version = "1.7.1")
  '';

  sysrootBuild = ''
    load("@bazel_skylib//rules/directory:directory.bzl", "directory")

    directory(
        name = "root",
        srcs = glob(["**/*"]),
        visibility = ["//visibility:public"],
    )

    # NOTE: Using this is better for merkle tree performance
    filegroup(
        name = "directory",
        srcs = ["."],
        visibility = ["//visibility:public"],
    )

    filegroup(
        name = "all_files",
        srcs = glob(["**"]),
        visibility = ["//visibility:public"],
    )
  '';

  installPhase = ''
    runHook preInstall

    gcc="${stdenv.cc.cc}"
    gccLib="${stdenv.cc.cc.lib}"
    gccVersion="$(basename "$(echo "$gcc"/include/c++/*)")"

    mkdir -p \
      "$out/sysroot/lib64" \
      "$out/sysroot/lib/x86_64-linux-gnu" \
      "$out/sysroot/usr/include" \
      "$out/sysroot/usr/lib" \
      "$out/sysroot/usr/lib/x86_64-linux-gnu" \
      "$out/sysroot/usr/lib/gcc/x86_64-unknown-linux-gnu" \
      "$out/sysroot/usr/lib/gcc/x86_64-linux-gnu" \
      "$out/sysroot/usr/include/c++" \
      "$out/sysroot/usr/include/x86_64-unknown-linux-gnu/c++" \
      "$out/sysroot/usr/include/x86_64-linux-gnu/c++"

    cp "$moduleBazelPath" "$out/MODULE.bazel"
    mkdir -p "$out/sysroot"
    cp "$sysrootBuildPath" "$out/sysroot/BUILD.bazel"

    # Real directories + file symlinks. `cp -rs` leaves directory symlinks into
    # the Nix store, which then cannot be merged (Permission denied).
    link_tree() {
      local src="$1"
      local dest="$2"
      [ -d "$src" ] || return 0
      mkdir -p "$dest"
      find "$src" -mindepth 1 \( -type f -o -type l \) -print |
        while IFS= read -r f; do
          # Directory symlinks (ncursesw -> ncurses, etc.) cycle Bazel's ** glob.
          [ -d "$f" ] && continue
          rel="''${f#"$src"/}"
          mkdir -p "$dest/$(dirname "$rel")"
          target="$(readlink -f "$f")"
          [ -f "$target" ] || continue
          ln -sfn "$target" "$dest/$rel"
        done
    }

    install_lib() {
      local libdir="$1"
      [ -d "$libdir" ] || return 0
      link_tree "$libdir" "$out/sysroot/lib64"
      link_tree "$libdir" "$out/sysroot/lib/x86_64-linux-gnu"
      link_tree "$libdir" "$out/sysroot/usr/lib/x86_64-linux-gnu"
      link_tree "$libdir" "$out/sysroot/usr/lib"
    }

    install_inc() {
      local incdir="$1"
      [ -d "$incdir" ] || return 0
      link_tree "$incdir" "$out/sysroot/usr/include"
    }

    # Kernel headers first so glibc can overlay libc-specific files.
    install_inc "${linuxHeaders}/include"
    install_inc "${glibc.dev}/include"
    install_lib "${glibc}/lib"
    install_lib "${libgcc}/lib"
    install_lib "$gccLib/lib"

    link_tree "$gcc/lib/gcc/x86_64-unknown-linux-gnu/$gccVersion" \
      "$out/sysroot/usr/lib/gcc/x86_64-unknown-linux-gnu/$gccVersion"
    ln -sfn "../x86_64-unknown-linux-gnu/$gccVersion" \
      "$out/sysroot/usr/lib/gcc/x86_64-linux-gnu/$gccVersion"

    link_tree "$gcc/include/c++/$gccVersion" "$out/sysroot/usr/include/c++/$gccVersion"
    ln -sfn "$gccVersion" "$out/sysroot/usr/include/c++/''${gccVersion%%.*}"

    if [ -d "$out/sysroot/usr/include/c++/$gccVersion/x86_64-unknown-linux-gnu" ]; then
      # From usr/include/<triple>/c++/<ver> -> usr/include/c++/<ver>/<triple>
      ln -sfn "../../c++/$gccVersion/x86_64-unknown-linux-gnu" \
        "$out/sysroot/usr/include/x86_64-unknown-linux-gnu/c++/$gccVersion"
      ln -sfn "../../c++/$gccVersion/x86_64-unknown-linux-gnu" \
        "$out/sysroot/usr/include/x86_64-linux-gnu/c++/$gccVersion"
    fi

    # Keep sysroot/lib/ as a real directory (Debian multiarch). lib64 only
    # needs the ELF interpreter path clang looks up as /lib64/ld-linux-*.
    ln -sfn lib "$out/sysroot/usr/lib64"

    install_lib "${zlib.out}/lib"
    install_inc "${zlib.dev}/include"
    install_lib "${xz.out}/lib"
    install_inc "${xz.dev}/include"
    install_lib "${zstd.out}/lib"
    install_inc "${zstd.dev}/include"
    install_lib "${ncurses.out}/lib"
    install_inc "${ncurses.dev}/include"
    # lldb asks for -lcurses; nixpkgs ncurses only ships libncurses.
    for dest in lib64 lib/x86_64-linux-gnu usr/lib/x86_64-linux-gnu usr/lib; do
      if [ -e "$out/sysroot/$dest/libncurses.so" ]; then
        ln -sfn libncurses.so "$out/sysroot/$dest/libcurses.so"
      fi
    done
    install_lib "${libmd.out}/lib"
    install_inc "${libmd.dev}/include"
    install_lib "${libbsd.out}/lib"
    install_inc "${libbsd.dev}/include"
    install_lib "${libxml2.out}/lib"
    install_inc "${libxml2.dev}/include"
    install_lib "${libffi.out}/lib"
    install_inc "${libffi.dev}/include"
    install_lib "${libedit}/lib"
    install_inc "${libedit.dev}/include"
    install_lib "${openssl.out}/lib"
    install_inc "${openssl.dev}/include"

    # lld --sysroot prefixes absolute paths in GNU ld scripts. Nix glibc scripts
    # point at /nix/store/.../lib which then cannot be found *inside* the sysroot.
    find "$out/sysroot" \( -type f -o -type l \) -name '*.so' |
      while IFS= read -r f; do
        real="$(readlink -f "$f" || true)"
        [ -n "$real" ] && [ -f "$real" ] || continue
        if grep -q 'GNU ld script' "$real" 2>/dev/null; then
          tmp="$TMPDIR/ldscript.$(basename "$f")"
          sed -E 's|/nix/store/[^/]+/lib(64)?/|/lib64/|g' "$real" >"$tmp"
          rm -f "$f"
          cp "$tmp" "$f"
        fi
      done

    runHook postInstall
  '';

  meta = {
    description = "nixpkgs glibc/libstdc++ sysroot for Modular's Mojo toolchain";
    license = lib.licenses.lgpl2Plus;
    platforms = [ "x86_64-linux" ];
  };
}
