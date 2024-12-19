{
  fetchGoModVendor,
  makeSetupHook,
  go,
  cacert,
  git,
  lib,
  stdenv,
}:

argsOrFun:

let

  # inherit given names from an attrset, but only if the name actually exists
  takeAttrs = names: lib.filterAttrs (n: _: lib.elem n names);

  # these are already handled manually
  namesToRemove = [
    "overrideModAttrs"
    "nativeBuildInputs"
    "passthru"
    "meta"
  ];

  configHook = makeSetupHook {
    name = "go-config-hook";
  } ./config-hook.sh;

  buildHook = makeSetupHook {
    name = "go-build-hook";
  } ./build-hook.sh;

  installHook = makeSetupHook {
    name = "go-install-hook";
  } ./install-hook.sh;

in

(stdenv.mkDerivation (
  finalAttrs:

  let
    args = if lib.isFunction argsOrFun then argsOrFun finalAttrs else argsOrFun;
  in
  {

    # The SRI hash of the vendored dependencies.
    # If `vendorHash` is `null`, no dependencies are fetched and
    # the build relies on the vendor folder within the source.
    vendorHash = throw "buildGoModule: vendorHash needs to be set";

    # Directory to the `go.mod` and `go.sum` relative to the `src`.
    modRoot = "./";

    # Whether to delete the vendor folder supplied with the source.
    deleteVendor = false;

    # Whether to fetch (go mod download) and proxy the vendor directory.
    # This is useful if your code depends on c code and go mod tidy does not
    # include the needed sources to build or if any dependency has case-insensitive
    # conflicts which will produce platform dependant `vendorHash` checksums.
    proxyVendor = false;

    # Do not enable this without good reason
    # IE: programs coupled with the compiler.
    allowGoReference = false;

    goModules =
      if (finalAttrs.vendorHash == null) then
        null
      else
        (fetchGoModVendor (
          (takeAttrs [
            "pname"
            "version"
            "name"
            "src"
            "srcs"
            "sourceRoot"

            "modRoot"
            "deleteVendor"
            "proxyVendor"
            "enableParallelBuilding"
          ] finalAttrs)
          // {
            hash = finalAttrs.vendorHash;
          }
        )).overrideAttrs
          finalAttrs.passthru.overrideModAttrs;

    # We want parallel builds by default.
    enableParallelBuilding = true;

    strictDeps = true;

    nativeBuildInputs = [
      go
      configHook
      buildHook
      installHook
    ] ++ args.nativeBuildInputs or [ ];

    # TODO: should probably be moved to the hooks
    inherit (go) GOOS GOARCH CGO_ENABLED;

    GO111MODULE = "on";
    GOTOOLCHAIN = "local";

    doCheck = true;

    disallowedReferences = lib.optional (!finalAttrs.allowGoReference) go;

    passthru = {
      inherit go;
      overrideModAttrs = args.overrideModAttrs or (finalAttrs: previousAttrs: { });
    } // args.passthru or { };

    meta = {
      # Add default meta information.
      platforms = go.meta.platforms or lib.platforms.all;
    } // args.meta or { };

    # TODO: move warnings to bash or remove them
    __warnings = lib.pipe null [
      (lib.warnIf (lib.any (lib.hasPrefix "-mod=")
        args.GOFLAGS or [ ]
      ) "use `proxyVendor` to control Go module/vendor behavior instead of setting `-mod=` in GOFLAGS")
      (lib.warnIf (builtins.elem "-trimpath" args.GOFLAGS or [ ])
        "`-trimpath` is added by default to GOFLAGS by buildGoModule when allowGoReference isn't set to true"
      )
      (lib.warnIf (builtins.elem "-buildid="
        args.ldflags or [ ]
      ) "`-buildid=` is set by default as ldflag by buildGoModule")
    ];

  }
  // lib.removeAttrs args namesToRemove
))
