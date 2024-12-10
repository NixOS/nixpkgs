{
  lib,
  stdenvNoCC,
  fetchzip,
  dict-type ? "core",
}:

let
  pname = "sudachidict";
  version = "20230927";

  srcs = {
    core = fetchzip {
      url = "https://github.com/WorksApplications/SudachiDict/releases/download/v${version}/sudachi-dictionary-${version}-core.zip";
      hash = "sha256-c88FfC03AU8eP37RVu9M3BAIlwFlTJqQJ60PK94mHOc=";
    };
    small = fetchzip {
      url = "https://github.com/WorksApplications/SudachiDict/releases/download/v${version}/sudachi-dictionary-${version}-small.zip";
      hash = "sha256-eaYD2C/qPeZJvmOeqH307a6OXtYfuksf6VZt+9kM7eM=";
    };
    full = fetchzip {
      url = "https://github.com/WorksApplications/SudachiDict/releases/download/v${version}/sudachi-dictionary-${version}-full.zip";
      hash = "sha256-yiO33UUQHcf6LvHJ1Is4MJtI5GSHuIP/tsE9m/KZ01o=";
    };
  };
in

lib.checkListOfEnum "${pname}: dict-type" [ "core" "full" "small" ] [ dict-type ]

  stdenvNoCC.mkDerivation
  {
    inherit pname version;

    src = srcs.${dict-type};

    dontConfigure = true;

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      install -Dm644 system_${dict-type}.dic $out/share/system.dic

      runHook postInstall
    '';

    passthru = {
      dict-type = dict-type;
    };

    meta = with lib; {
      description = "A lexicon for Sudachi";
      homepage = "https://github.com/WorksApplications/SudachiDict";
      changelog = "https://github.com/WorksApplications/SudachiDict/releases/tag/v${version}";
      license = licenses.asl20;
      maintainers = with maintainers; [ natsukium ];
      platforms = platforms.all;
      # it is a waste of space and time to build this package in hydra since it is just data
      hydraPlatforms = [ ];
    };
  }
