{
  stdenv,
  fetchFromGitHub,
  lib,
}:

stdenv.mkDerivation rec {
  pname = "clolcat";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "IchMageBaume";
    repo = "clolcat";
    rev = version;
    sha256 = "sha256-fLa239dwEXe4Jyy5ntgfU9V0h5wrBsvq6/s2HCis7Sc=";
  };

  preInstall = "mkdir -p $out/bin";

  makeFlags = [ "DESTDIR=$(out)/bin" ];

  meta = with lib; {
    description = "Much faster lolcat";
    homepage = "https://github.com/IchMageBaume/clolcat";
    platforms = platforms.all;
    maintainers = [ maintainers.felipeqq2 ];
    license = licenses.wtfpl;
    mainProgram = "clolcat";
  };
}
