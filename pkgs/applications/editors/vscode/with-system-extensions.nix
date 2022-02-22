{ lib, stdenv, runCommand, buildEnv, vscode, makeWrapper, libredirect-self
, vscodeExtensions ? [] }:

/*
  ```bash
  $ nix-shell -I nixpkgs=. -E 'with (import <nixpkgs> {}); vscode-with-system-extensions.override {vscodeExtensions = with vscode-extensions; [bbenoist.nix]; }'
  $ rm -rf "$PWD/build" &&  out="$PWD/build" genericBuild
  ```

  ```bash
  $ nix-build -I nixpkgs=. -E 'with (import <nixpkgs> {}); vscode-with-system-extensions.override {vscodeExtensions = with vscode-extensions; [bbenoist.nix ms-vsliveshare.vsliveshare]; }'
  ```
*/

let
  inherit (vscode) executableName longName;
  wrappedPkgVersion = lib.getVersion vscode;
  wrappedPkgName = lib.removeSuffix "-${wrappedPkgVersion}" vscode.name;

  combinedExtensionsDrv = buildEnv {
    name = "vscode-extensions";
    paths = vscodeExtensions;
  };

in

# When no extensions are requested, we simply redirect to the original
# non-wrapped vscode executable.
runCommand "${wrappedPkgName}-with-system-extensions-${wrappedPkgVersion}" {
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ vscode ];
  dontPatchELF = true;
  dontStrip = true;
  meta = vscode.meta;
} ''
  symlink_reinstall_as_real_copy() {
    declare sl_f="''${1?}"
    if ! [[ -L "$sl_f" ]]; then
      1>&2 printf -- "ERROR: Won't reinstall '%s'." "$sl_f"
      1>&2 printf -- " -> Not a symlink."
    fi
    declare in_f
    in_f="$(realpath "$sl_f")";
    unlink "$sl_f"
    cp "$in_f" "$sl_f"
  }

  symlink_reinstall_as_real_mut_dir() {
    declare sl_f="''${1?}"
    if ! [[ -L "$sl_f" ]]; then
      1>&2 printf -- "ERROR: Won't reinstall '%s'." "$sl_f"
      1>&2 printf -- " -> Not a symlink."
    fi
    declare in_f
    in_f="$(realpath "$sl_f")";
    unlink "$sl_f"
    cp -r "$in_f" "$sl_f"
    chmod -R u+w "$sl_f"
  }

  symlinks_expand_dir() {
    declare curr_dir="''${1?}"
    if ! [[ -L "$curr_dir" ]]; then
      1>&2 printf -- "ERROR: Cannot expand '%s'." "$curr_dir"
      1>&2 printf -- " -> Not a symlink."
    fi
    declare in_dir
    in_dir="$(realpath "$curr_dir")"

    unlink "$curr_dir"
    mkdir -p "$curr_dir"

    declare f
    declare bn
    for f in $(find "$in_dir" -mindepth 1 -maxdepth 1); do
      bn="$(basename "$f")"
      ln -sT "$f" "$curr_dir/$bn"
    done
  }

  symlinks_expand_from_dir_to_sub_dirs() {
    declare start_dir="''${1?}"
    shift 1

    declare curr_dir="$start_dir"
    symlinks_expand_dir "$curr_dir"

    declare seg_to_ext_dir=( "$@" )
    for s in "''${seg_to_ext_dir[@]}"; do
      curr_dir="$curr_dir/$s"
      symlinks_expand_dir "$curr_dir"
    done
  }

  mkdir -p "$out"
  ln -sT "${vscode}/lib" "$out/lib"

  symlinks_expand_from_dir_to_sub_dirs "$out/lib" "vscode" "resources" "app" "extensions"

  declare in_ext_dir="${combinedExtensionsDrv}/share/vscode/extensions"

  if [[ -e "$in_ext_dir" ]]; then
    for f in $(find "${combinedExtensionsDrv}/share/vscode/extensions" -mindepth 1 -maxdepth 1); do
      bn="$(basename "$f")";
      out_f="$out/lib/vscode/resources/app/extensions/$bn"
      if [[ -e "$out_f" ]]; then
        # 1>&2 printf -- "ERROR: System extension '%s' already exist." "$out_f"
        # 1>&2 printf -- " -> Not allowed to be replaced by '%s'." "$f"
        # false

        # Silently replace existing system package with extension.
        unlink "$out_f"
      fi
      ln -sT "$f" "$out_f"
    done
  fi

  # Works fine. This seems to be required not to use symlinks.
  symlink_reinstall_as_real_mut_dir "$out/lib/vscode/resources/app/out"

  # Workaround awaiting <https://github.com/electron/electron/issues/31121>.
  # It the current time, it is impossible to share an electron binary
  # between 2 apps.
  # TODO: Avoid this copy by using a 'LD_PRELOAD' trick. Launching
  # with 'strace', I can see the following query for the current
  # executable:
  # 'readlink("/proc/self/exe", "/home/rgauthier/dev/nixpkgs_latest/build/lib/vscode/code", 4096) = 56'.
  # Example at 'pkgs/build-support/libredirect/libredirect.c'.
  symlink_reinstall_as_real_copy "$out/lib/vscode/code"


  # TODO: Investigate. Causes trouble.
  # declare code_exe="$out/lib/vscode/code"
  # declare real_code_exe="$(realpath "$code_exe")"
  # unlink "$code_exe"
  # makeWrapper \
  #   "$real_code_exe" \
  #   "$code_exe" \
  #   --set NIX_SELF_REDIRECTS "''${real_code_exe}=''${code_exe}" \
  #   --set LD_PRELOAD "${libredirect-self}/lib/libredirect-self.so"

  ln -sT "${vscode}/share" "$out/share"

  mkdir -p "$out/bin"
  for f in $(find "${vscode}/bin" -mindepth 1 -maxdepth 1); do
    bn="$(basename "$f")"
    out_f="$out/bin/$bn"
    install "$f" "$out_f"
    substituteInPlace "$out_f" --replace "${vscode}" "$out"
  done
''
