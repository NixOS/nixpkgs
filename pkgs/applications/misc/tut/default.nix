{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tut";
  version = "0.0.42";

  src = fetchFromGitHub {
    owner = "RasmusLindroth";
    repo = pname;
    rev = version;
    sha256 = "sha256-zWhG9lzerzDqqFN8IG5JSv3voLzvtp/gg6jBisbodMc=";
  };

  vendorSha256 = "sha256-kMGEAN/I2XsIc6zCDbhbbstYlyjDpXQsOPUzjaJqJBk=";

  meta = with lib; {
    description = "A TUI for Mastodon with vim inspired keys";
    homepage = "https://github.com/RasmusLindroth/tut";
    license = licenses.mit;
    maintainers = with maintainers; [ equirosa ];
    platforms = platforms.unix;
  };
}
