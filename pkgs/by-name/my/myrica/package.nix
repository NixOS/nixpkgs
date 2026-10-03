{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation {
  pname = "myrica";
  version = "2.011.20160403";

  src = fetchFromGitHub {
    owner = "tomokuni";
    repo = "Myrica";
    # commit does not exist on any branch on the target repository
    rev = "b737107723bfddd917210f979ccc32ab3eb6dc20";
    hash = "sha256-kx+adbN2DsO81KJFt+FGAPZN+1NpE9xiagKZ4KyaJV0=";
  };

  nativeBuildInputs = [ installFonts ];

  # only collect font collections

  includeFonts = [
    "Myrica"
    "MyricaM"
  ];

  meta = {
    homepage = "https://myrica.estable.jp/";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ mikoim ];
    platforms = lib.platforms.all;
  };
}
