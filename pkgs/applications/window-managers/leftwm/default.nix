{ lib, fetchFromGitHub, rustPlatform, libX11, libXinerama, makeWrapper }:

let
    rpath = lib.makeLibraryPath [ libXinerama libX11 ];
in

rustPlatform.buildRustPackage rec {
  pname = "leftwm";
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "leftwm";
    repo = "leftwm";
    rev = version;
    sha256 = "sha256-T4A9NGT6sUSTKmLcAWjcp3Y8QQzZFAVSXevXtGm3szY=";
  };

  cargoSha256 = "sha256-2prRtdBxpYc2xI/bLZNlqs3mxESfO9GhNUSlKFF//eE=";

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
