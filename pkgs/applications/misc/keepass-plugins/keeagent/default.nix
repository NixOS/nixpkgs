{ stdenv, buildEnv, fetchzip, mono }:

let
  version = "0.10.1";
  drv = stdenv.mkDerivation {
    name = "keeagent-${version}";

    src = fetchzip {
      url = "https://lechnology.com/wp-content/uploads/2018/04/KeeAgent_v0.10.1.zip";
      sha256 = "0j7az6l9wcr8z66mfplkxwydd4bgz2p2vd69xncf0nxlfb0lshh7";
      stripRoot = false;
    };

    meta = {
      description = "KeePass plugin to allow other programs to access SSH keys stored in a KeePass database for authentication";
      homepage    = "http://lechnology.com/software/keeagent";
      platforms   = with stdenv.lib.platforms; linux;
      license     = stdenv.lib.licenses.gpl2;
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
