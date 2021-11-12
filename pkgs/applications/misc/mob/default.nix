{ lib, buildGoPackage, fetchFromGitHub}:

buildGoPackage rec {
  pname = "mob";
  version = "2.0.0";
  goPackagePath = "github.com/remotemobprogramming/mob";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "remotemobprogramming";
    repo = pname;
    sha256 = "sha256-sSeXL+eHroxDr+91rwmUJ+WwDgefZgJBRTxy4wo6DDM=";
  };

  meta = with lib; {
    description = "Tool for swift git handover";
    homepage = "https://github.com/remotemobprogramming/mob";
    license = licenses.mit;
    maintainers = [ maintainers.ericdallo ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
