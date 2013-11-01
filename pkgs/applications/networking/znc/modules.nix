{ stdenv, fetchurl, fetchgit,  znc }:

let

  zncDerivation = a@{
    name, src, module_name,
    buildPhase ? "${znc}/bin/znc-buildmod ${module_name}.cpp",
    installPhase ? "install -D ${module_name}.so $out/lib/znc/${module_name}.so", ...
  } : stdenv.mkDerivation (a // {
    inherit buildPhase;
    inherit installPhase;

    meta.platforms = stdenv.lib.platforms.unix;
    passthru.module_name = module_name;
  });

in rec {

  push = zncDerivation rec {
    name = "znc-push-${version}";
    version = "1.0.0";
    module_name = "push";

    src = fetchurl {
        url = "https://github.com/jreese/znc-push/archive/v${version}.tar.gz";
        sha256 = "1v9a16b1d8mfzhddf4drh6rbxa0szr842g7614r8ninmc0gi7a2v";
    };

    meta = {
      description = "Push notification service module for ZNC";
      homepage = https://github.com/jreese/znc-push;
      repositories.git = https://github.com/jreese/znc-push.git;
      license = stdenv.lib.license.mit;
      maintainers = [ stdenv.lib.maintainers.offline ];
    };
  };

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

}
