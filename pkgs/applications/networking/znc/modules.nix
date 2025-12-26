{
  lib,
  stdenv,
  fetchFromGitHub,
  znc,
  cmake,
  pkg-config,
  python3,
  which,
}:

let
  zncDerivation =
    a@{
      pname,
      src,
      module_name,
      buildPhase ? ''
        runHook preBuild

        ${znc}/bin/znc-buildmod ${module_name}.cpp

        runHook postBuild
      '',
      installPhase ? ''
        runHook preInstall

        install -D ${module_name}.so $out/lib/znc/${module_name}.so

        runHook postInstall
      '',
      ...
    }:
    stdenv.mkDerivation (
      a
      // {
        inherit buildPhase installPhase;

        nativeBuildInputs = [
          python3
          which
          cmake
          pkg-config
        ];

        dontUseCmakeConfigure = true;

        buildInputs = znc.buildInputs;

        passthru.module_name = module_name;

        meta = a.meta // {
          platforms = lib.platforms.unix;
        };
      }
    );

in
{

  backlog = zncDerivation {
    pname = "znc-backlog";
    version = "0-unstable-2018-08-24";
    module_name = "backlog";

    src = fetchFromGitHub {
      owner = "FruitieX";
      repo = "znc-backlog";
      rev = "44314a6aca0409ae59b0d841807261be1159fff4";
      hash = "sha256-yhoMuwXul6zq4VPGn810PlFwiCUIvvV6wkQupE3svOQ=";
    };

    meta = {
      description = "Request backlog for IRC channels";
      homepage = "https://github.com/fruitiex/znc-backlog/";
      license = lib.licenses.asl20;
      maintainers = [ ];
    };
  };

  clientbuffer = zncDerivation {
    pname = "znc-clientbuffer";
    version = "0-unstable-2021-05-30";
    module_name = "clientbuffer";

    src = fetchFromGitHub {
      owner = "CyberShadow";
      repo = "znc-clientbuffer";
      rev = "9a7465b413b53408f5d7af86e84b1d08efb6bec0";
      hash = "sha256-pAj4Iot0RFuNJOLSZFaXoH5BPb4vf0H8KPfIoo0kbig=";
    };

    meta = {
      description = "ZNC module for client specific buffers";
      homepage = "https://github.com/CyberShadow/znc-clientbuffer";
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [
        szlend
        cybershadow
      ];
    };
  };

  clientaway = zncDerivation {
    pname = "znc-clientaway";
    version = "0-unstable-2017-04-28";
    module_name = "clientaway";

    src = fetchFromGitHub {
      owner = "kylef-archive";
      repo = "znc-contrib";
      rev = "f6724a4a3b16b050088adde0cbeed74f189e5044";
      hash = "sha256-KBd78ucRFbgV/jILS1OSsZqqKyjT4RmBfiBTKX8bbUY=";
    };

    meta = {
      description = "ZNC clientaway module";
      homepage = "https://github.com/kylef-archive/znc-contrib";
      license = lib.licenses.gpl2;
      maintainers = [ ];
    };
  };

  fish = zncDerivation {
    pname = "znc-fish";
    version = "0-unstable-2017-06-26";
    module_name = "fish";

    src = fetchFromGitHub {
      # this fork works with ZNC 1.7
      owner = "oilslump";
      repo = "znc-fish";
      rev = "7d91467dbb195f7b591567911210523c6087662e";
      hash = "sha256-VW/je7vDc9arbrj848T0bbeqP9qx7Az5SMOVecLrxc8=";
    };

    meta = {
      description = "ZNC FiSH module";
      homepage = "https://github.com/oilslump/znc-fish";
      maintainers = [ lib.maintainers.offline ];
    };
  };

  ignore = zncDerivation {
    pname = "znc-ignore";
    version = "0-unstable-2017-04-28";
    module_name = "ignore";

    src = fetchFromGitHub {
      owner = "kylef";
      repo = "znc-contrib";
      rev = "f6724a4a3b16b050088adde0cbeed74f189e5044";
      hash = "sha256-KBd78ucRFbgV/jILS1OSsZqqKyjT4RmBfiBTKX8bbUY=";
    };

    meta = {
      description = "ZNC ignore module";
      homepage = "https://github.com/kylef/znc-contrib";
      license = lib.licenses.gpl2;
      maintainers = [ ];
    };
  };

  palaver = zncDerivation rec {
    pname = "znc-palaver";
    version = "1.2.2";
    module_name = "palaver";

    src = fetchFromGitHub {
      owner = "cocodelabs";
      repo = "znc-palaver";
      tag = version;
      hash = "sha256-8W3uF1PrLQiEZm7JaFrpqmJLSFioa4F4qlM1J6Zua8U=";
    };

    meta = {
      description = "Palaver ZNC module";
      homepage = "https://github.com/cocodelabs/znc-palaver";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ szlend ];
    };
  };

  playback = zncDerivation {
    pname = "znc-playback";
    version = "0-unstable-2020-05-10";
    module_name = "playback";

    src = fetchFromGitHub {
      owner = "jpnurmi";
      repo = "znc-playback";
      rev = "8dd128bfe2b24b2cc6a9ea2e2d28bfaa28d2a833";
      hash = "sha256-/hmwhrWDYGzjfmTeCB4mk+FABAJNZvREnuxzvzl6uo4=";
    };

    meta = {
      description = "Advanced playback module for ZNC";
      homepage = "https://github.com/jpnurmi/znc-playback";
      license = lib.licenses.asl20;
    };
  };

  privmsg = zncDerivation {
    pname = "znc-privmsg";
    version = "0-unstable-2017-04-28";
    module_name = "privmsg";

    src = fetchFromGitHub {
      owner = "kylef";
      repo = "znc-contrib";
      rev = "f6724a4a3b16b050088adde0cbeed74f189e5044";
      hash = "sha256-KBd78ucRFbgV/jILS1OSsZqqKyjT4RmBfiBTKX8bbUY=";
    };

    meta = {
      description = "ZNC privmsg module";
      homepage = "https://github.com/kylef/znc-contrib";
    };
  };

  push = zncDerivation rec {
    pname = "znc-push";
    version = "1.1.0";
    module_name = "push";

    src = fetchFromGitHub {
      owner = "jreese";
      repo = "znc-push";
      tag = "v${version}";
      hash = "sha256-OS2nIU/DlESpJT82cWhb75TizSO7LQr74CMz09ulKyQ=";
    };

    meta = {
      description = "Push notification service module for ZNC";
      homepage = "https://github.com/jreese/znc-push";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        offline
      ];
    };
  };
}
