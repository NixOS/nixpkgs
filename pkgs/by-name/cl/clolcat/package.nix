{
  stdenv,
  fetchFromGitHub,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clolcat";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "IchMageBaume";
    repo = "clolcat";
    rev = finalAttrs.version;
    sha256 = "sha256-fLa239dwEXe4Jyy5ntgfU9V0h5wrBsvq6/s2HCis7Sc=";
  };

  preInstall = "mkdir -p $out/bin";

  makeFlags = [ "DESTDIR=$(out)/bin" ];

  meta = {
    description = "Much faster lolcat";
    homepage = "https://github.com/IchMageBaume/clolcat";
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.felipeqq2 ];
    license = lib.licenses.wtfpl;
    mainProgram = "clolcat";
  };
})
