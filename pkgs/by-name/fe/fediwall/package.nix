{
  lib,
  stdenv,
  fediwall-unwrapped,
  conf ? { },
}:

if (conf == { }) then
  fediwall-unwrapped
else
  stdenv.mkDerivation {
    pname = "fediwall";
    inherit (fediwall-unwrapped) version meta;

    dontUnpack = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      ln -s ${fediwall-unwrapped}/* $out
      echo ${lib.escapeShellArg (builtins.toJSON conf)} \
          > "$out/wall-config.json"
      runHook postInstall
    '';
  }
