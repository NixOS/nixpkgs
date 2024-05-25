{
  stdenv,
  callPackage,
  runCommand,
  writeShellApplication,
  lib,
  makeWrapper,
  substituteAll,
}:
let
  arch = stdenv.targetPlatform.uname.processor;
  hare = callPackage ./hare-unwrapped.nix { };
  wrapperScript = writeShellApplication {
    # `name` must be `hare`, since this scripts replaces the hare binary.
    name = "hare";
    excludeShellChecks = [ "SC2086" ];
    runtimeInputs = [ hare ];
    # ''${1:+"$1"} is used on the default case to keep the same behavior as
    # the hare binary: If "$cmd" is passed directly and it's empty, the hare
    # binary will treat it as an unrecognized command.
    text = ''
      case "''${1-}" in
      build|test|run) exec hare "$1" ''${NIX_HAREFLAGS-} "''${@:2}" ;;
      *) exec hare ''${1:+"$1"} "$@" ;;
      esac
    '';
  };
  hareWrapped = runCommand "hare-wrapped" { nativeBuildInputs = [ makeWrapper ]; } ''
    mkdir -p $out/bin
    install -m0755 ${lib.getExe wrapperScript} $out/bin
    makeWrapper ${lib.getExe hare} $out/bin/hare-native \
      --inherit-argv0 \
      --unset AS \
      --unset LD \
      --unset CC
  '';
  setupHook = substituteAll {
    src = ./setup-hook.sh;
    hare_unconditional_flags = "-q -a${arch}";
    hare_stdlib = "${hare}/src/hare/stdlib";
  };
in
stdenv.mkDerivation {
  inherit (hare) pname version;

  propagatedBuildInputs = builtins.attrValues {
    inherit (hare) harec qbe;
    inherit hareWrapped;
  };

  dontUnpack = true;
  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontInstall = true;

  inherit setupHook;

  # Needed for haredoc.
  passthru = {
    inherit (hare) src;
  };

  inherit (hare) meta;
}
