{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "miscfiles";
  version = "1.5";

  src = fetchurl {
    url = "mirror://gnu/miscfiles/miscfiles-${finalAttrs.version}.tar.gz";
    sha256 = "005588vfrwx8ghsdv9p7zczj9lbc9a3r4m5aphcaqv8gif4siaka";
  };

  meta = {
    homepage = "https://www.gnu.org/software/miscfiles/";
    license = lib.licenses.gpl2Plus;
    description = "Collection of files not of crucial importance for sysadmins";
    maintainers = with lib.maintainers; [ pSub ];
    platforms = with lib.platforms; unix;
  };
})
