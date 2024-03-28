{ hare, stdenv, lib }:
# Based on php's buildComposerProject:
# <https://github.com/NixOS/nixpkgs/blob/4e0a85752775cb57f81af602fe19cd1d39c8179f/pkgs/build-support/php/build-composer-project.nix>
let
  hareBuildPackageOverride = finalAttrs: previousAttrs:
    let
      arch = stdenv.hostPlatform.uname.processor;
      drvHareFlags =
        if !previousAttrs?hareFlags then [ ]
        else
          builtins.filter (x: !(lib.hasPrefix "-a" x))
            previousAttrs.hareFlags;
      hareFlags = lib.concatStringsSep " "
        ([
          "-q"
          "-R"
          "-a${arch}"
        ] ++ drvHareFlags);
      hareSetupPhase = ''
        export PREFIX="$out"
        echoCmd "PREFIX" "$PREFIX"
        HARECACHE="$(mktemp -d)"
        export HARECACHE
        echoCmd "HARECACHE" "$HARECACHE"
        export HAREFLAGS="${hareFlags}"
        echoCmd "HAREFLAGS" "$HAREFLAGS"
        makeFlagsArray+=(
          PREFIX="$PREFIX"
          HARECACHE="$HARECACHE"
          HAREFLAGS="${hareFlags}"
        )
      '';
      prePhases = [ "hareSetupPhase" ];
      nativeBuildInputs' = previousAttrs.nativeBuildInputs or [ ];
      meta' = previousAttrs.meta or { };
      # Warnings.
      isArchSetByDrv = lib.any (x: (lib.hasPrefix "-a" x)) previousAttrs.hareFlags or [ ];
      archSetByDrvMsg = "`-a` hare flag ignored; using `${arch}` (`stdenv.hostPlatform.uname.processor`) instead";
      isHareOnNativeBuildInputs = lib.any (x: x.pname or "" == "hare") nativeBuildInputs';
      hareOnNativeBuildInputsMsg = "`hare` is already added to `nativeBuildInputs`";
      isMetaPlatformsSet = meta'?platforms;
      metaPlatformsSetMsg = "`platforms` ignored; using `{ inherit (hare.meta) platforms; }`";
      isMetaBadPlatformsSet = meta'?badPlatforms;
      metaBadPlatformsSetMsg = "`badPlatforms` ignored; using `{ inherit (hare.meta) badPlatforms; }`";
    in
    lib.warnIf
      isArchSetByDrv
      archSetByDrvMsg
      lib.warnIf
      isHareOnNativeBuildInputs
      hareOnNativeBuildInputsMsg
      lib.warnIf
      isMetaPlatformsSet
      metaPlatformsSetMsg
      lib.warnIf
      isMetaBadPlatformsSet
      metaBadPlatformsSetMsg

      previousAttrs // {
      inherit hareSetupPhase prePhases;
      nativeBuildInputs = nativeBuildInputs' ++ [ hare ];
      meta = meta' // { inherit (hare.meta) platforms badPlatforms; };
    };
in
args: (stdenv.mkDerivation args).overrideAttrs hareBuildPackageOverride
