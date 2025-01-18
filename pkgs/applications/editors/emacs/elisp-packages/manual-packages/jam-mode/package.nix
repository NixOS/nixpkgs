{
  lib,
  melpaBuild,
  fetchurl,
}:

melpaBuild rec {
  pname = "jam-mode";
  version = "0.3";

  src = fetchurl {
    url = "https://dev.gentoo.org/~ulm/distfiles/${pname}-${version}.el.xz";
    hash = "sha256-0IlYqbPa4AAwOpjdd20k8hqtvDhZmcz1WHa/LHx8kMk=";
  };

  unpackPhase = ''
    runHook preUnpack

    xz -cd $src > jam-mode.el

    runHook postUnpack
  '';

  postPatch = ''
    echo ";;; jam-mode.el ---" > tmp.el
    cat jam-mode.el >> tmp.el
    mv tmp.el jam-mode.el
  '';

  meta = with lib; {
    description = "Emacs major mode for editing Jam files";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ qyliss ];
  };
}
