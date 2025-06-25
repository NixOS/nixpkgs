{
  lib,
  stdenvNoCC,
  fetchzip,
  dict-type ? "core",
}:

let
  pname = "sudachidict";
  version = "20250129";

  srcs = {
    core = fetchzip {
      url = "https://github.com/WorksApplications/SudachiDict/releases/download/v${version}/sudachi-dictionary-${version}-core.zip";
      hash = "sha256-aoUS+PM/gBGBU8HJqJB9Pbw7FNCWu8sp81DamtlFsXc=";
    };
    small = fetchzip {
      url = "https://github.com/WorksApplications/SudachiDict/releases/download/v${version}/sudachi-dictionary-${version}-small.zip";
      hash = "sha256-+50hcgXmtVZ7rFCInmSjoGGJCLOnax9UcqN5CmQcgGI=";
    };
    full = fetchzip {
      url = "https://github.com/WorksApplications/SudachiDict/releases/download/v${version}/sudachi-dictionary-${version}-full.zip";
      hash = "sha256-2dKHI3TKF3aIWdN2lhcCbjRdJOH91rJNsdC7o0Wdlj0=";
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
