{
  lib,
  stdenvNoCC,
  apple-sdk,
  gperf,
  bison,
  flex,
  bootstrap_cmds,
}:
# apple-sdk's XcodeDefault.xctoolchain/usr/bin is a minimal stub (lipo/nm/…).
# Chromium on mac with use_system_xcode expects host tools like gperf/mig there
# ($mac_bin_path/gperf, and `mig` on PATH for crashpad). Overlay nixpkgs tools.
stdenvNoCC.mkDerivation {
  name = "brave-origin-darwin-devtools";
  inherit (apple-sdk) version;

  buildCommand = ''
    mkdir -p "$out"

    for d in Platforms Library usr nix-support; do
      if [ -e "${apple-sdk}/$d" ]; then
        ln -s "${apple-sdk}/$d" "$out/$d"
      fi
    done

    toolchainSrc="${apple-sdk}/Toolchains/XcodeDefault.xctoolchain"
    toolchainOut="$out/Toolchains/XcodeDefault.xctoolchain"
    mkdir -p "$toolchainOut/usr/bin"

    if [ -d "$toolchainSrc" ]; then
      for entry in "$toolchainSrc"/*; do
        name="$(basename "$entry")"
        if [ "$name" = "usr" ]; then
          mkdir -p "$toolchainOut/usr"
          for u in "$entry"/*; do
            uname="$(basename "$u")"
            if [ "$uname" = "bin" ]; then
              for bin in "$u"/*; do
                ln -s "$bin" "$toolchainOut/usr/bin/$(basename "$bin")"
              done
            else
              ln -s "$u" "$toolchainOut/usr/$uname"
            fi
          done
        else
          ln -s "$entry" "$toolchainOut/$name"
        fi
      done
    fi

    ln -sfn "${gperf}/bin/gperf" "$toolchainOut/usr/bin/gperf"
    ln -sfn "${bison}/bin/bison" "$toolchainOut/usr/bin/bison"
    ln -sfn "${flex}/bin/flex" "$toolchainOut/usr/bin/flex"

    # Expose bootstrap_cmds with its real layout so `mig` can find
    # ../libexec/migcom (do not symlink mig into the toolchain bin).
    mkdir -p "$out/bootstrap_cmds"
    ln -sfn "${bootstrap_cmds}/bin" "$out/bootstrap_cmds/bin"
    if [ -d "${bootstrap_cmds}/libexec" ]; then
      ln -sfn "${bootstrap_cmds}/libexec" "$out/bootstrap_cmds/libexec"
    fi
  '';

  meta = {
    description = "apple-sdk Developer dir with nixpkgs host tools for Chromium mac builds";
    platforms = lib.platforms.darwin;
  };
}
