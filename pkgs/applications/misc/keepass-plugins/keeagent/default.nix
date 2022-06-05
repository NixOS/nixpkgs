{ lib, stdenv, buildEnv, fetchzip, mono }:

let
  version = "0.12.0";
  drv = stdenv.mkDerivation {
    pname = "keeagent";
    inherit version;

    src = fetchzip {
      url = "https://lechnology.com/wp-content/uploads/2020/05/KeeAgent_v0.12.0.zip";
      sha256 = "0fcfbj3yikiv3dmp69236h9r3c416amdq849kn131w1129gb68xd";
      stripRoot = false;
    };

    meta = {
      description = "KeePass plugin to allow other programs to access SSH keys stored in a KeePass database for authentication";
      homepage    = "http://lechnology.com/software/keeagent";
      platforms   = with lib.platforms; linux;
      license     = lib.licenses.gpl2;
      maintainers = [ ];
    };

    pluginFilename = "KeeAgent.plgx";

    installPhase = ''
      mkdir -p $out/lib/dotnet/keepass/
      cp $pluginFilename $out/lib/dotnet/keepass/$pluginFilename
    '';
  };
in
  # Mono is required to compile plugin at runtime, after loading.
  buildEnv { name = drv.name; paths = [ mono drv ]; }
