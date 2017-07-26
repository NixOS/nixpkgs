{ stdenv, buildEnv, fetchzip, mono }:

let
  version = "0.8.1";
  drv = stdenv.mkDerivation {
    name = "keeagent-${version}";

    src = fetchzip {
      url = http://lechnology.com/wp-content/uploads/2016/07/KeeAgent_v0.8.1.zip;
      sha256 = "16x1qrnzg0xkvi7w29wj3z0ldmql2vcbwxksbsmnidzmygwg98hk";
      stripRoot = false;
    };

    meta = {
      description = "KeePass plugin to allow other programs to access SSH keys stored in a KeePass database for authentication";
      homepage    = http://lechnology.com/software/keeagent;
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
