{
  lib,
  stdenv,
  fetchFromGitHub,
  curl,
  iup,
}:

stdenv.mkDerivation rec {
  pname = "sgdboop";
  version = "1.2.8";

  src = fetchFromGitHub {
    owner = "SteamGridDB";
    repo = "SGDBoop";
    rev = "v${version}";
    hash = "sha256-bdSzTwObMEBe1pHTDwXeJ3GXmOwwFp4my7qTmifX218=";
  };

  makeFlags = [
    # Makefile copies a bundled libiup.so, so put it somewhere it won't be found
    "USER_LIB_PATH=ignored"

    # The Flakepak install just copies things to /app - otherwise wants to do things with XDG
    "FLATPAK_ID=fake"
  ];

  postPatch = ''
    substituteInPlace "linux-release/com.steamgriddb.SGDBoop.desktop" \
      --replace "Exec=" "Exec=$out/bin/"
    substituteInPlace Makefile \
      --replace "/app/" "$out/"
  '';

  postInstall = ''
    rm -r "$out/share/metainfo"
  '';

  buildInputs = [
    curl
    iup
  ];

  meta = {
    description = "A program used for applying custom artwork to Steam, using SteamGridDB";
    homepage = "https://github.com/SteamGridDB/SGDBoop/";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ saturn745 ];
    mainProgram = "SGDBoop";
    platforms = lib.platforms.linux;
  };
}
