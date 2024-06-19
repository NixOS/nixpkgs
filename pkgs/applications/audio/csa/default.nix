{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "csa";
  version = "0.5.100810";

  src = fetchurl {
    url = "mirror://sourceforge/csa/${pname}-${version}.tar.gz";
    sha256 = "1syg81dzdil0dyx1mlx1n7if3qsf2iz243p2zv34a1acfqm509r3";
  };

  # after running either cellular leveler mono or stereo, the other stops working,
  # so we remove one of them:
  postInstall = "rm $out/lib/ladspa/celllm_3890.*";

  meta = with lib; {
    homepage = "https://sourceforge.net/projects/csa/";
    description = "Group of LADSPA Audio plugins for FM broadcast and more";
    longDescription = ''
      CSA means : Contrôle Signal Audio.
      It contains the following plugins:
      Emphazised Limiter, Cellular Leveler, Simple right/left amplifier. Blind Peak Meter.
    '';
    license = licenses.gpl3;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.unix;
  };
}
