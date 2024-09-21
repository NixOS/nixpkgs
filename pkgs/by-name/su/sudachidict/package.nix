{ lib
, stdenvNoCC
, fetchzip
, dict-type ? "core"
}:

let
  pname = "sudachidict";
  version = "20240716";

  srcs = {
    core = fetchzip {
      url = "https://github.com/WorksApplications/SudachiDict/releases/download/v${version}/sudachi-dictionary-${version}-core.zip";
      hash = "sha256-6Sps7Q2AdQRJfhRf9oibLLIpgmNL//74lzCmTKXy7sU=";
    };
    small = fetchzip {
      url = "https://github.com/WorksApplications/SudachiDict/releases/download/v${version}/sudachi-dictionary-${version}-small.zip";
      hash = "sha256-cZveAFaTpjaL/ge5Qv6zUzXYlNI/oLDivNnAa37gNYY=";
    };
    full = fetchzip {
      url = "https://github.com/WorksApplications/SudachiDict/releases/download/v${version}/sudachi-dictionary-${version}-full.zip";
      hash = "sha256-Mu0JgR3G6CRIzh25cCGhsUQBnfotOzRYzEC5Lma+n8s=";
    };
  };
in

lib.checkListOfEnum "${pname}: dict-type" [ "core" "full" "small" ] [ dict-type ]

stdenvNoCC.mkDerivation {
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
    description = "Lexicon for Sudachi";
    homepage = "https://github.com/WorksApplications/SudachiDict";
    changelog = "https://github.com/WorksApplications/SudachiDict/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ natsukium ];
    platforms = platforms.all;
    # it is a waste of space and time to build this package in hydra since it is just data
    hydraPlatforms = [];
  };
}
