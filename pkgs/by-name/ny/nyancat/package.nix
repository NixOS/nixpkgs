{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nyancat";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "klange";
    repo = "nyancat";
    rev = finalAttrs.version;
    sha256 = "1mg8nm5xzcq1xr8cvx24ym2vmafkw53rijllwcdm9miiz0p5ky9k";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace /usr/bin "$out/bin" \
      --replace /usr/share "$out/share"
  '';

  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1
  '';

  meta = {
    description = "Nyancat in your terminal, rendered through ANSI escape sequences";
    homepage = "https://nyancat.dakko.us";
    license = lib.licenses.ncsa;
    maintainers = with lib.maintainers; [ midchildan ];
    platforms = lib.platforms.unix;
    mainProgram = "nyancat";
  };
})
