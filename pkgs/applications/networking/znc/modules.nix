{ lib, stdenv, fetchFromGitHub, znc }:

let
  zncDerivation =
    a@{ pname
    , src
    , module_name
    , buildPhase ? "${znc}/bin/znc-buildmod ${module_name}.cpp"
    , installPhase ? "install -D ${module_name}.so $out/lib/znc/${module_name}.so"
    , ...
    }: stdenv.mkDerivation (a // {
      inherit buildPhase;
      inherit installPhase;

      buildInputs = znc.buildInputs;

      meta = a.meta // { platforms = lib.platforms.unix; };
      passthru.module_name = module_name;
    });

in
{

  backlog = zncDerivation rec {
    pname = "znc-backlog";
    version = "unstable-2017-06-13";
    module_name = "backlog";

    src = fetchFromGitHub {
      owner = "FruitieX";
      repo = "znc-backlog";
      rev = "42e8f439808882d2dae60f2a161eabead14e4b0d";
      sha256 = "1k7ifpqqzzf2j7w795q4mx1nvmics2higzjqr3mid3lp43sqg5s6";
    };

    meta = with lib; {
      description = "Request backlog for IRC channels";
      homepage = "https://github.com/fruitiex/znc-backlog/";
      license = licenses.asl20;
      maintainers = [ ];
    };
  };

  clientbuffer = zncDerivation rec {
    pname = "znc-clientbuffer";
    version = "unstable-2021-05-30";
    module_name = "clientbuffer";

    src = fetchFromGitHub {
      owner = "CyberShadow";
      repo = "znc-clientbuffer";
      rev = "9a7465b413b53408f5d7af86e84b1d08efb6bec0";
      sha256 = "0a3f4j6s5j7p53y42zrgpqyl2zm0jxb69lp24j6mni3licigh254";
    };

    meta = with lib; {
      description = "ZNC module for client specific buffers";
      homepage = "https://github.com/CyberShadow/znc-clientbuffer";
      license = licenses.asl20;
      maintainers = with maintainers; [ hrdinka szlend cybershadow ];
    };
  };

  clientaway = zncDerivation rec {
    pname = "znc-clientaway";
    version = "unstable-2017-04-28";
    module_name = "clientaway";

    src = fetchFromGitHub {
      owner = "kylef";
      repo = "znc-contrib";
      rev = "f6724a4a3b16b050088adde0cbeed74f189e5044";
      sha256 = "0ikd3dzjjlr0gs0ikqfk50msm6mij99ln2rjzqavh58iwzr7n5r8";
    };

    meta = with lib; {
      description = "ZNC clientaway module";
      homepage = "https://github.com/kylef/znc-contrib";
      license = licenses.gpl2;
      maintainers = with maintainers; [ ];
    };
  };

  fish = zncDerivation rec {
    pname = "znc-fish";
    version = "unstable-2017-06-26";
    module_name = "fish";

    src = fetchFromGitHub {
      # this fork works with ZNC 1.7
      owner = "oilslump";
      repo = "znc-fish";
      rev = "7d91467dbb195f7b591567911210523c6087662e";
      sha256 = "1ky5xg17k5f393whrv5iv8zsmdvdyk2f7z5qdsmxcwy3pdxy6vsm";
    };

    meta = {
      description = "ZNC FiSH module";
      homepage = "https://github.com/dctrwatson/znc-fish";
      maintainers = [ lib.maintainers.offline ];
    };
  };

  ignore = zncDerivation rec {
    pname = "znc-ignore";
    version = "unstable-2017-04-28";
    module_name = "ignore";

    src = fetchFromGitHub {
      owner = "kylef";
      repo = "znc-contrib";
      rev = "f6724a4a3b16b050088adde0cbeed74f189e5044";
      sha256 = "0ikd3dzjjlr0gs0ikqfk50msm6mij99ln2rjzqavh58iwzr7n5r8";
    };

    meta = with lib; {
      description = "ZNC ignore module";
      homepage = "https://github.com/kylef/znc-contrib";
      license = licenses.gpl2;
      maintainers = with maintainers; [ ];
    };
  };

  palaver = zncDerivation rec {
    pname = "znc-palaver";
    version = "1.2.2";
    module_name = "palaver";

    src = fetchFromGitHub {
      owner = "cocodelabs";
      repo = "znc-palaver";
      rev = version;
      hash = "sha256-8W3uF1PrLQiEZm7JaFrpqmJLSFioa4F4qlM1J6Zua8U=";
    };

    meta = with lib; {
      description = "Palaver ZNC module";
      homepage = "https://github.com/cocodelabs/znc-palaver";
      license = licenses.mit;
      maintainers = with maintainers; [ szlend ];
    };
  };

  playback = zncDerivation rec {
    pname = "znc-playback";
    version = "unstable-2015-08-04";
    module_name = "playback";

    src = fetchFromGitHub {
      owner = "jpnurmi";
      repo = "znc-playback";
      rev = "8691abf75becc1f3d7b5bb5ad68dad17cd21863b";
      sha256 = "0mgfajljy035051b2sx70i8xrb51zw9q2z64kf85zw1lynihzyh4";
    };

    meta = with lib; {
      description = "Advanced playback module for ZNC";
      homepage = "https://github.com/jpnurmi/znc-playback";
      license = licenses.asl20;
      maintainers = with maintainers; [ hrdinka ];
    };
  };

  privmsg = zncDerivation rec {
    pname = "znc-privmsg";
    version = "unstable-2015-02-22";
    module_name = "privmsg";

    src = fetchFromGitHub {
      owner = "kylef";
      repo = "znc-contrib";
      rev = "9f1f98db56cbbea96d83e6628f657e0d62cd9517";
      sha256 = "0n82z87gdxxragcaixjc80z8bw4bmfwbk0jrf9zs8kk42phlkkc2";
    };

    meta = {
      description = "ZNC privmsg module";
      homepage = "https://github.com/kylef/znc-contrib";
    };
  };

  push = zncDerivation rec {
    pname = "znc-push";
    version = "unstable-2016-10-12";
    module_name = "push";

    src = fetchFromGitHub {
      owner = "jreese";
      repo = "znc-push";
      rev = "cf08b9e0f483f03c28d72dd78df932cbef141f10";
      sha256 = "0xpwjw8csyrg736g1jc1n8d6804x6kbdkrvldzhk9ldj4iwqz7ay";
    };

    meta = {
      description = "Push notification service module for ZNC";
      homepage = "https://github.com/jreese/znc-push";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ offline schneefux ];
    };
  };

}
