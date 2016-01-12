{ stdenv, fetchurl, fetchgit, znc }:

let
  zncDerivation = a@{
    name, src, module_name,
    buildPhase ? "${znc}/bin/znc-buildmod ${module_name}.cpp",
    installPhase ? "install -D ${module_name}.so $out/lib/znc/${module_name}.so", ...
  } : stdenv.mkDerivation (a // {
    inherit buildPhase;
    inherit installPhase;

    meta = a.meta // { platforms = stdenv.lib.platforms.unix; };
    passthru.module_name = module_name;
  });

in rec {

  fish = zncDerivation rec {
    name = "znc-fish-8e1f150fda";
    module_name = "fish";

    src = fetchgit {
        url = meta.repositories.git;
        rev = "8e1f150fdaf18dc33e023795584dec8255e6614e";
        sha256 = "0vpk4336c191irl3g7wibblnbqf3903hjrci4gs0qgg1wvj7fw66";
    };

    meta = {
      description = "ZNC FiSH module";
      homepage = https://github.com/dctrwatson/znc-fish;
      repositories.git = https://github.com/dctrwatson/znc-fish.git;
      maintainers = [ stdenv.lib.maintainers.offline ];
    };
  };

  privmsg = zncDerivation rec {
    name        = "znc-privmsg-c9f98690be";
    module_name = "privmsg";

    src = fetchgit {
      url    = meta.repositories.git;
      rev    = "c9f98690beb4e3a7681468d5421ff11dc8e1ee8b";
      sha256 = "dfeb28878b12b98141ab204191288cb4c3f7df153a01391ebf6ed6a32007247f";
    };

    meta = {
      description = "ZNC privmsg module";
      homepage = https://github.com/kylef/znc-contrib;
      repositories.git = https://github.com/kylef/znc-contrib.git;
    };
  };

  push = zncDerivation rec {
    name = "znc-push-${version}";
    version = "git-2015-12-07";
    module_name = "push";

    src = fetchgit {
      url = "https://github.com/jreese/znc-push.git";
      rev = "717a2b1741eee75456b0862ef76dbb5af906e936";
      sha256 = "1lr5bhcy8156f7sbah7kjgz4g4mhkkwgvwjd2rxpbwnpq3ssza9k";
    };

    meta = {
      description = "Push notification service module for ZNC";
      homepage = https://github.com/jreese/znc-push;
      repositories.git = https://github.com/jreese/znc-push.git;
      license = stdenv.lib.licenses.mit;
      maintainers = [ stdenv.lib.maintainers.offline ];
    };
  };

}
