{
  lib,
  stdenv,
  buildEnv,
  fetchurl,
  mono,
}:

let
  version = "1.0.0";

  drv = stdenv.mkDerivation {
    pname = "keepass-charactercopy";
    inherit version;

    src = fetchurl {
      url = "https://github.com/SketchingDev/Character-Copy/releases/download/v${version}/CharacterCopy.plgx";
      sha256 = "f8a81a60cd1aacc04c92a242479a8e4210452add019c52ebfbb1810b58d8800a";
    };

    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/lib/dotnet/keepass/
      cp $src $out/lib/dotnet/keepass/
    '';

    meta = with lib; {
      description = "Enables KeePass to copy individual characters by index";
      longDescription = ''
        Character Copy is a lightweight KeePass plugin that integrates into KeePass' entry menu and
        allows users to securely copy individual characters from
        an entry's protected string fields, such as the password field
      '';
      homepage = "https://github.com/SketchingDev/Character-Copy";
      platforms = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
      ];
      # licensing info was found in source files https://github.com/SketchingDev/Character-Copy/search?q=license
      license = licenses.gpl2;
      maintainers = with maintainers; [ nazarewk ];
    };
  };
in
# Mono is required to compile plugin at runtime, after loading.
buildEnv {
  name = drv.name;
  paths = [
    mono
    drv
  ];
}
