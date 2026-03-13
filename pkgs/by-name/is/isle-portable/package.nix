{
  lib,
  callPackage,
  requireFile,
  runCommand,
  makeBinaryWrapper,
  symlinkJoin,
  isle-portable-unwrapped ? callPackage ./unwrapped.nix { },
  _7zz,
}:
let
  legoIslandIso = requireFile {
    name = "LEGO_ISLANDI.ISO";
    hash = "sha256-pefu/XcvGKcWYzaFldWeFEYdc7OUBgbmlgWyH2CnZec=";
    message = "ISO file of Lego Island 1.1";
  };

  unpackedIso = runCommand "LEGO_ISLANDI-unpacked" { nativeBuildInputs = [ _7zz ]; } ''
    mkdir "$out"
    7zz x ${legoIslandIso} -o"$out"
  '';
in
symlinkJoin (
  finalAttrs:
  let
    # INI file with the LEGO Island Disk files in it
    iniWithDisk = lib.recursiveUpdate finalAttrs.passthru.iniConfig {
      isle = {
        diskpath = "${unpackedIso}/DATA/disk";
        cdpath = "${unpackedIso}";
      };
    };

    # Properly quoted INI file
    quotedIni = lib.mapAttrsRecursiveCond (as: (!lib.isDerivation as)) (
      _: value: ''"${toString value}"''
    ) iniWithDisk;

    # Make a config ini file
    iniFile =
      runCommand "isle.ini"
        {
          passAsFile = [ "iniFile" ];

          # Set the ISO path.
          iniFile = lib.generators.toINI { } quotedIni;
        }
        ''
          cp "$iniFilePath" "$out"
        '';
  in
  {
    inherit (isle-portable-unwrapped) version;
    pname = "isle-portable-wrapped";

    paths = [
      isle-portable-unwrapped
    ];

    nativeBuildInputs = [
      makeBinaryWrapper
    ];

    postBuild = ''
      wrapProgram "$out/bin/isle" \
        --add-flags "--ini ${iniFile}"
    '';

    passthru.unwrapped = isle-portable-unwrapped;

    passthru.iniConfig = {
      isle = {
        diskpath = null;
        cdpath = null;
        mediapath = isle-portable-unwrapped;
        savepath = "~/.local/share/isledecomp/isle";
        "flip surfaces" = "false";
        "full screen" = "true";
        "exclusive full screen" = "true";
        "wide view angle" = "true";
        "3dsound" = "true";
        "music" = "true";
        "cursor sensitivity" = "4.000000";
        "back buffers in video ram" = "-1";
        "island quality" = "2";
        "island texture" = "1";
        "max lod" = "3.600000";
        "max allowed extras" = "20";
        "transition type" = "3";
        "touch scheme" = "2";
        "haptic" = "true";
        "horizontal resolution" = "640";
        "vertical resolution" = "480";
        "exclusive x resolution" = "640";
        "exclusive y resolution" = "480";
        "exclusive framerate" = "60";
        "frame delta" = "10";
        "msaa" = "0";
        "anisotropic" = "";
      };

      extensions = {
        "texture loader" = "false";
        "si loader" = "false";
      };
    };

    meta = removeAttrs isle-portable-unwrapped.meta [ "position" ];
  }
)
