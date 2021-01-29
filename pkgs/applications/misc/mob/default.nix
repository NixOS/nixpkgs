{ lib, buildGoPackage, fetchFromGitHub}:

buildGoPackage rec {
  pname = "mob";
  version = "1.1.0";
  goPackagePath = "github.com/remotemobprogramming/mob";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "remotemobprogramming";
    repo = pname;
    sha256 = "sha256-C63tGMd+kGQc99k7L8SKlijlEBaBCiksAghsg6WC8Bw=";
  };

  meta = with lib; {
    description = "Tool for swift git handover";
    homepage = "https://github.com/remotemobprogramming/mob";
    license = licenses.mit;
    maintainers = [ maintainers.ericdallo ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
