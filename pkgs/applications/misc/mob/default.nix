{ lib, buildGoPackage, fetchFromGitHub}:

buildGoPackage rec {
  pname = "mob";
  version = "1.9.0";
  goPackagePath = "github.com/remotemobprogramming/mob";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "remotemobprogramming";
    repo = pname;
    sha256 = "sha256-PvFECy5wgpdOdToeYsW+NiVC2LXkBCMBorIl8m++Lic=";
  };

  meta = with lib; {
    description = "Tool for swift git handover";
    homepage = "https://github.com/remotemobprogramming/mob";
    license = licenses.mit;
    maintainers = [ maintainers.ericdallo ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
