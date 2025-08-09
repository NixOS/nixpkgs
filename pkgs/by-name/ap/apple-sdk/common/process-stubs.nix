let
  removedDylibs = [
    # corecrypto is available under a very restrictive license (effectively: non-free, can’t use).
    # Without the headers and not being able to use corecrypto due to its license, it’s not very useful.
    # Stubs are included in the SDK for all dylibs, including corecrypto. They should be removed.
    "/usr/lib/system/libcorecrypto.dylib"
  ];
in

{
  lib,
  jq,
  llvm,
}:

self: super: {
  nativeBuildInputs = super.nativeBuildInputs or [ ] ++ [
    jq
    llvm
  ];

  buildPhase = super.buildPhase or "" + ''
    echo "Removing the following dylibs from the libSystem reexported libraries list: ${lib.escapeShellArg (lib.concatStringsSep ", " removedDylibs)}"
    for libSystem in libSystem.B.tbd libSystem.B_asan.tbd; do
      # tbd-v5 is a JSON-based format, which can be manipulated by `jq`.
      llvm-readtapi --filetype=tbd-v5 usr/lib/$libSystem \
      | jq --argjson libs ${lib.escapeShellArg (builtins.toJSON removedDylibs)} '
        if .libraries then
          .libraries[] |= select(.install_names[] | any([.] | inside($libs)) | not)
        else
          .
        end
        | .main_library.reexported_libraries[].names[] |= select([.] | inside($libs) | not)
      ' > usr/lib/$libSystem~
      # Convert libSystem back to tbd-v4 because not all tooling supports the JSON-based format yet.
      llvm-readtapi --filetype=tbd-v4 usr/lib/$libSystem~ -o usr/lib/$libSystem
      rm usr/lib/$libSystem~
    done

    # Strip weak C++ symbols to work around `libc++` leakage in system
    # frameworks for now. These are only present on `x86_64-darwin`, so
    # it should hopefully be harmless.
    #
    # TODO FIXME: This is kind of horrible.
    while read -r -d "" stub; do
      printf 'Stripping weak C++ symbols from %s\n' "$stub"
      llvm-readtapi --filetype=tbd-v5 "$stub" \
      | jq '
        (.main_library, .libraries[]?).exported_symbols[]?.data.weak[]? |=
          select(startswith("__Z") | not)
      ' > $stub~
      llvm-readtapi --filetype=tbd-v4 $stub~ -o $stub
      rm $stub~
    done < <(find . -name '*.tbd' -print0)
  '';
}
