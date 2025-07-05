{
  lib,
  stdenvNoCC,
  fetchzip,
  dict-type ? "core",
}:

let
  pname = "sudachidict";
  version = "20250515";

  srcs = {
    core = fetchzip {
      url = "https://github.com/WorksApplications/SudachiDict/releases/download/v${version}/sudachi-dictionary-${version}-core.zip";
      hash = "sha256-+N6B1eW8ScDJSjMWjSNJlQAEOCNh5Q0lcsAWrY9eRVE=";
    };
    small = fetchzip {
      url = "https://github.com/WorksApplications/SudachiDict/releases/download/v${version}/sudachi-dictionary-${version}-small.zip";
      hash = "sha256-+0pg2wXS1Y/5LGnVvEbtEpws2LqFPv88jCHsV+Oxb5E=";
    };
    full = fetchzip {
      url = "https://github.com/WorksApplications/SudachiDict/releases/download/v${version}/sudachi-dictionary-${version}-full.zip";
      hash = "sha256-jYFZax9LDLX6knGuQDhbhdDU3WGjevVkDFF/XZx2kg0=";
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
