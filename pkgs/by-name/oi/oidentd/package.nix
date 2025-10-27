{
  lib,
  stdenv,
  fetchurl,
  bison,
  flex,
}:

stdenv.mkDerivation rec {
  pname = "oidentd";
  version = "3.1.0";
  nativeBuildInputs = [
    bison
    flex
  ];

  src = fetchurl {
    url = "https://files.janikrabe.com/pub/oidentd/releases/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-yyvcnabxNkcIMOiZBjvoOm/pEjrGXFt4W4SG5lprkbc=";
  };

  postPatch = ''
    substituteInPlace src/oidentd.h \
      --replace-fail \
        '#define MASQ_MAP${"\t\t"}SYSCONFDIR "/oidentd_masq.conf"' \
        '#define MASQ_MAP${"\t\t"}"/etc/oidentd/oidentd_masq.conf"' \
      --replace-fail \
        '#define CONFFILE${"\t\t"}SYSCONFDIR "/oidentd.conf"' \
        '#define CONFFILE${"\t\t"}"/etc/oidentd/oidentd.conf"'
  '';

  meta = {
    description = "Configurable Ident protocol server";
    mainProgram = "oidentd";
    homepage = "https://oidentd.janikrabe.com/";
    changelog = "https://github.com/janikrabe/oidentd/blob/${version}/NEWS";
    license = lib.licenses.gpl2Only;
    platforms = with lib.platforms; linux ++ freebsd ++ openbsd ++ netbsd;
    maintainers = with lib.maintainers; [ h7x4 ];
  };
}
