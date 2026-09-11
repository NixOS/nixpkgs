{
  lib,
  libretro,
  makeBinaryWrapper,
  retroarch-bare,
  symlinkJoin,
  writeText,
  cores ? [ ],
  settings ? { },
}:

let
  # All cores should be located in the same path after symlinkJoin,
  # but let's be safe here
  coresPath = lib.lists.unique (map (c: c.libretroCore) cores);
  declarativeSettings =
    lib.optionalAttrs (coresPath != [ ]) {
      libretro_directory = "@retroarch@" + lib.last coresPath;
    }
    // settings;
  settingsPath = writeText "declarative-retroarch.cfg" (
    lib.generators.toKeyValue {
      mkKeyValue = lib.generators.mkKeyValueDefault {
        mkValueString = v: ''"${v}"'';
      } " = ";
    } declarativeSettings
  );
in
symlinkJoin {
  pname = "retroarch-with-cores";
  version = lib.getVersion retroarch-bare;

  paths = [ retroarch-bare ] ++ cores;

  nativeBuildInputs = [ makeBinaryWrapper ];

  passthru = {
    inherit cores;
    unwrapped = retroarch-bare;
    withCores = coreFun: retroarch-bare.wrapper { cores = (coreFun libretro); };
  };

  postBuild = ''
    # remove core specific binaries
    find $out/bin -name 'retroarch-*' -type l -delete

    # Unlike -L <directory>, appended settings survive configuration reloads
    # when closing content or unloading core/game overrides.
    mkdir -p $out/share/retroarch
    substitute ${settingsPath} $out/share/retroarch/declarative-retroarch.cfg \
      --subst-var-by retroarch "$out"
    wrapProgram $out/bin/retroarch \
      --add-flags "--appendconfig=$out/share/retroarch/declarative-retroarch.cfg"
  '';

  meta = {
    inherit (retroarch-bare.meta)
      changelog
      description
      homepage
      license
      mainProgram
      maintainers
      teams
      platforms
      ;

    longDescription = ''
      RetroArch is the reference frontend for the libretro API.
    ''
    + lib.optionalString (cores != [ ]) ''
      The following cores are included: ${lib.concatStringsSep ", " (map (c: c.core) cores)}.
    '';
  };
}
