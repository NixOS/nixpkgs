{
  hare,
  lib,
  makeSetupHook,
  makeWrapper,
  runCommand,
  stdenv,
  writeShellApplication,
}:
let
  arch = stdenv.targetPlatform.uname.processor;
  harePropagationInputs = builtins.attrValues { inherit (hare) harec qbe; };
  hareWrappedScript = writeShellApplication {
    # `name` MUST be `hare`, since its role is to replace the hare binary.
    name = "hare";
    runtimeInputs = [ hare ];
    excludeShellChecks = [ "SC2086" ];
    # ''${cmd:+"$cmd"} is used on the default case to keep the same behavior as
    # the hare binary: If "$cmd" is passed directly and it's empty, the hare
    # binary will treat it as an unrecognized command.
    text = ''
      readonly cmd="$1"
      shift
      case "$cmd" in
        "test"|"run"|"build") exec hare "$cmd" $NIX_HAREFLAGS "$@" ;;
        *) exec hare ''${cmd:+"$cmd"} "$@"
      esac
    '';
  };
  hareWrapper = runCommand "hare-wrapper" { nativeBuildInputs = [ makeWrapper ]; } ''
    mkdir -p $out/bin
    install ${lib.getExe hareWrappedScript} $out/bin/hare
    makeWrapper ${lib.getExe hare} $out/bin/hare-native \
      --inherit-argv0 \
      --unset AR \
      --unset LD \
      --unset CC
  '';
in
makeSetupHook {
  name = "hare-hook";
  # The propagation of `qbe` and `harec` (harePropagationInputs) is needed for
  # build frameworks like `haredo`, which set the HAREC and QBE env vars to
  # `harec` and `qbe` respectively. We use the derivations from the `hare`
  # package to assure that there's no different behavior between the `hareHook`
  # and `hare` packages.
  propagatedBuildInputs = [ hareWrapper ] ++ harePropagationInputs;
  substitutions = {
    hare_unconditional_flags = "-q -a${arch}";
    hare_stdlib = "${hare}/src/hare/stdlib";
  };
  meta = {
    description = "A setup hook for the Hare compiler";
    inherit (hare.meta) badPlatforms platforms;
  };
} ./setup-hook.sh
