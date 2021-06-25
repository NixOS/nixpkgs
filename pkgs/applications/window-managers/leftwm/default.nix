{ lib, fetchFromGitHub, rustPlatform, libX11, libXinerama, makeWrapper }:

let
    rpath = lib.makeLibraryPath [ libXinerama libX11 ];
in

rustPlatform.buildRustPackage rec {
  pname = "leftwm";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "leftwm";
    repo = "leftwm";
    rev = version;
    sha256 = "sha256-nRPt+Tyfq62o+3KjsXkHQHUMMslHFGNBd3s2pTb7l4w=";
  };

  cargoSha256 = "sha256-lmzA7XM8B5QJI4Wo0cKeMR3+np6jT6mdGzTry4g87ng=";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ libX11 libXinerama ];

  postInstall = ''
    wrapProgram $out/bin/leftwm --prefix LD_LIBRARY_PATH : "${rpath}"
    wrapProgram $out/bin/leftwm-state --prefix LD_LIBRARY_PATH : "${rpath}"
    wrapProgram $out/bin/leftwm-worker --prefix LD_LIBRARY_PATH : "${rpath}"
  '';

  meta = with lib; {
    description = "A tiling window manager for the adventurer";
    homepage = "https://github.com/leftwm/leftwm";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mschneider ];
    changelog = "https://github.com/leftwm/leftwm/blob/${version}/CHANGELOG";
  };
}
