{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "nyancat";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "klange";
    repo = "nyancat";
    rev = version;
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

  meta = with lib; {
    description = "Nyancat in your terminal, rendered through ANSI escape sequences";
    homepage = "https://nyancat.dakko.us";
    license = licenses.ncsa;
    maintainers = with maintainers; [ midchildan ];
    platforms = platforms.unix;
    mainProgram = "nyancat";
  };
}
