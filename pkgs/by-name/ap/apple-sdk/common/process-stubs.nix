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
  libtapi,
}:

self: super: {
  nativeBuildInputs = super.nativeBuildInputs or [ ] ++ [
    jq
    libtapi
  ];

  buildPhase =
    super.buildPhase or ""
    + ''
      echo "Removing the following dylibs from the libSystem reexported libraries list: ${lib.escapeShellArg (lib.concatStringsSep ", " removedDylibs)}"
      for libSystem in libSystem.B.tbd libSystem.B_asan.tbd; do
        tapi stubify --filetype=tbd-v5 usr/lib/$libSystem -o usr/lib/$libSystem # tbd-v5 is a JSON-based format.
        jq --argjson libs ${lib.escapeShellArg (builtins.toJSON removedDylibs)} '
          if .libraries then
            .libraries[] |= select(.install_names[] | any([.] | inside($libs)) | not)
          else
            .
          end
          | .main_library.reexported_libraries[].names[] |= select([.] | inside($libs) | not)
        ' usr/lib/$libSystem > usr/lib/$libSystem~
        mv usr/lib/$libSystem~ usr/lib/$libSystem
      done

      # Rewrite the text-based stubs to v4 using `tapi`. This ensures a consistent format between SDK versions.
      # tbd-v4 also drops certain elements that are no longer necessary (such as GUID lists).
      find . -name '*.tbd' -type f \
        -exec echo "Converting {} to tbd-v4" \; \
        -exec tapi stubify --filetype=tbd-v4 {} -o {} \;
    '';
}
