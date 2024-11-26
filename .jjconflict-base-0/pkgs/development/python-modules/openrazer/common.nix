{ lib, fetchFromGitHub }:
rec {
  version = "3.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openrazer";
    repo = "openrazer";
    rev = "v${version}";
    hash = "sha256-MLwhqLPWdjg1ZUZP5Sig37RgZEeHlU+DyELpyMif6iY=";
  };

  meta = with lib; {
    homepage = "https://openrazer.github.io/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ evanjs ] ++ teams.lumiguide.members;
    platforms = platforms.linux;
  };
}
