{ lib, buildGoPackage, fetchFromGitHub}:

buildGoPackage rec {
  pname = "mob";
  version = "2.1.0";
  goPackagePath = "github.com/remotemobprogramming/mob";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "remotemobprogramming";
    repo = pname;
    sha256 = "sha256-K8ID8cetzCaMc/PVRNMyIhrshtEUiD6U/jI4e0TcOO4=";
  };

  meta = with lib; {
    description = "Tool for swift git handover";
    homepage = "https://github.com/remotemobprogramming/mob";
    license = licenses.mit;
    maintainers = [ maintainers.ericdallo ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
