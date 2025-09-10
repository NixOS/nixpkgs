{
  delve,
  autoPatchelfHook,
  stdenv,
  lib,
  glibc,
  gcc-unwrapped,
}:
# This is a list of plugins that need special treatment. For example, the go plugin (id is 9568) comes with delve, a
# debugger, but that needs various linking fixes. The changes here replace it with the system one.
{
  "631" = {
    # Python
    nativeBuildInputs = lib.optional stdenv.hostPlatform.isLinux autoPatchelfHook;
    buildInputs = [ (lib.getLib stdenv.cc.cc) ];
  };
  "7322" = {
    # Python community edition
    nativeBuildInputs = lib.optional stdenv.hostPlatform.isLinux autoPatchelfHook;
    buildInputs = [ (lib.getLib stdenv.cc.cc) ];
  };
  "8182" = {
    # Rust (deprecated)
    nativeBuildInputs = lib.optional stdenv.hostPlatform.isLinux autoPatchelfHook;
    buildInputs = [ (lib.getLib stdenv.cc.cc) ];
    buildPhase = ''
      runHook preBuild
      chmod +x -R bin
      runHook postBuild
    '';
  };
  "9568" = {
    # Go
    buildInputs = [ delve ];
    buildPhase =
      let
        arch =
          (if stdenv.hostPlatform.isLinux then "linux" else "mac")
          + (if stdenv.hostPlatform.isAarch64 then "arm" else "");
      in
      ''
        runHook preBuild
        ln -sf ${delve}/bin/dlv lib/dlv/${arch}/dlv
        runHook postBuild
      '';
  };
  "17718" = {
    # Github Copilot
    # Modified version of https://github.com/ktor/nixos/commit/35f4071faab696b2a4d86643726c9dd3e4293964
    buildPhase = ''
      agent='copilot-agent/native/${lib.toLower stdenv.hostPlatform.uname.system}${
        {
          x86_64 = "-x64";
          aarch64 = "-arm64";
        }
        .${stdenv.hostPlatform.uname.processor} or ""
      }/copilot-language-server'
      orig_size=$(stat --printf=%s $agent)

      find_payload_offset() {
        grep -aobUam1 -f <(printf '\x1f\x8b\x08\x00') "$agent" | cut -d: -f1
      }

      # Helper: find the offset of the prelude by searching for function string start
      find_prelude_offset() {
        local prelude_string='(function(process, require, console, EXECPATH_FD, PAYLOAD_POSITION, PAYLOAD_SIZE) {'
        grep -obUa -- "$prelude_string" "$agent" | cut -d: -f1
      }

      before_payload_position="$(find_payload_offset)"
      before_prelude_position="$(find_prelude_offset)"

      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $agent
      patchelf --set-rpath ${
        lib.makeLibraryPath [
          glibc
          gcc-unwrapped
        ]
      } $agent
      chmod +x $agent
      new_size=$(stat --printf=%s $agent)
      var_skip=20
      var_select=22
      shift_by=$(($new_size-$orig_size))
      function fix_offset {
        # $1 = name of variable to adjust
        location=$(grep -obUam1 "$1" $agent | cut -d: -f1)
        location=$(expr $location + $var_skip)
        value=$(dd if=$agent iflag=count_bytes,skip_bytes skip=$location \
        bs=1 count=$var_select status=none)
        value=$(expr $shift_by + $value)
        echo -n $value | dd of=$agent bs=1 seek=$location conv=notrunc
      }

      after_payload_position="$(find_payload_offset)"
      after_prelude_position="$(find_prelude_offset)"

      if [ "${stdenv.hostPlatform.system}" == "aarch64-linux" ]
      then
        fix_offset PAYLOAD_POSITION
        fix_offset PRELUDE_POSITION
      else
        # There are hardcoded positions in the binary, then it replaces the placeholders by himself
        sed -i -e "s/$before_payload_position/$after_payload_position/g" "$agent"
        sed -i -e "s/$before_prelude_position/$after_prelude_position/g" "$agent"
      fi
    '';
  };
  "22407" = {
    # Rust
    nativeBuildInputs = lib.optional stdenv.hostPlatform.isLinux autoPatchelfHook;
    buildInputs = [ (lib.getLib stdenv.cc.cc) ];
    buildPhase = ''
      runHook preBuild
      chmod +x -R bin
      runHook postBuild
    '';
  };
}
