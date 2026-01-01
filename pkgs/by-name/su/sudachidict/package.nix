{
  lib,
  stdenvNoCC,
  fetchzip,
  dict-type ? "core",
}:

let
  pname = "sudachidict";
<<<<<<< HEAD
  version = "20251022";
=======
  version = "20250515";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  srcs = {
    core = fetchzip {
      url = "https://github.com/WorksApplications/SudachiDict/releases/download/v${version}/sudachi-dictionary-${version}-core.zip";
<<<<<<< HEAD
      hash = "sha256-kfYGjDO7kO0Gy0YhBceetl2B51iH3myCVt3MCo9nYq0=";
    };
    small = fetchzip {
      url = "https://github.com/WorksApplications/SudachiDict/releases/download/v${version}/sudachi-dictionary-${version}-small.zip";
      hash = "sha256-Y8vX4+G5JB0AmiKP5lGYh/t3NeXSgyGd0Wvv6qFpikE=";
    };
    full = fetchzip {
      url = "https://github.com/WorksApplications/SudachiDict/releases/download/v${version}/sudachi-dictionary-${version}-full.zip";
      hash = "sha256-w/yBWslxIIdniR9c3LN4G4n94VqT73506u/knL9/Pj8=";
=======
      hash = "sha256-+N6B1eW8ScDJSjMWjSNJlQAEOCNh5Q0lcsAWrY9eRVE=";
    };
    small = fetchzip {
      url = "https://github.com/WorksApplications/SudachiDict/releases/download/v${version}/sudachi-dictionary-${version}-small.zip";
      hash = "sha256-+0pg2wXS1Y/5LGnVvEbtEpws2LqFPv88jCHsV+Oxb5E=";
    };
    full = fetchzip {
      url = "https://github.com/WorksApplications/SudachiDict/releases/download/v${version}/sudachi-dictionary-${version}-full.zip";
      hash = "sha256-jYFZax9LDLX6knGuQDhbhdDU3WGjevVkDFF/XZx2kg0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
      updateScript = ./update.sh;
    };

    meta = {
      description = "Lexicon for Sudachi";
      homepage = "https://github.com/WorksApplications/SudachiDict";
      changelog = "https://github.com/WorksApplications/SudachiDict/releases/tag/v${version}";
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [ natsukium ];
      platforms = lib.platforms.all;
      # it is a waste of space and time to build this package in hydra since it is just data
      hydraPlatforms = [ ];
    };
  }
