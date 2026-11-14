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
    hash = "sha256-M/lZLvgx1lQb45TKmEfh06m6RfVE9M1Q7gGz30u16NU=";
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
