{
  lib,
  stdenv,
  buildEnv,
  fetchFromGitHub,
  mono,
}:

let
  version = "1.8.4.2";
  drv = stdenv.mkDerivation {
    pname = "keepasshttp";
    inherit version;
    src = fetchFromGitHub {
      owner = "pfn";
      repo = "keepasshttp";
      # rev = version;
      # for 1.8.4.2 the tag is at the wrong commit (they fixed stuff
      # afterwards and didn't move the tag), hence reference by commitid
      rev = "c2c4eb5388a02169400cba7a67be325caabdcc37";
      sha256 = "0bkzxggbqx7sql3sp46bqham6r457in0vrgh3ai3lw2jrw79pwmh";
    };

    meta = {
      description = "KeePass plugin to expose password entries securely (256bit AES/CBC) over HTTP";
      homepage = "https://github.com/pfn/keepasshttp";
      platforms = with lib.platforms; linux;
      license = lib.licenses.gpl3;
    };

    pluginFilename = "KeePassHttp.plgx";

    installPhase = ''
      mkdir -p $out/lib/dotnet/keepass/
      cp $pluginFilename $out/lib/dotnet/keepass/$pluginFilename
    '';
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
