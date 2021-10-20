{ lib, buildGoPackage, fetchFromGitHub}:

buildGoPackage rec {
  pname = "mob";
  version = "1.12.0";
  goPackagePath = "github.com/remotemobprogramming/mob";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "remotemobprogramming";
    repo = pname;
    sha256 = "sha256-5hvuaKlaWrB8nEeHytnn4ywciLbOSoXdBdc3K/PqMG8=";
  };

  meta = with lib; {
    description = "Tool for swift git handover";
    homepage = "https://github.com/remotemobprogramming/mob";
    license = licenses.mit;
    maintainers = [ maintainers.ericdallo ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
