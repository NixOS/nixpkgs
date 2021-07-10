{ lib, fetchFromGitHub, rustPlatform, libX11, libXinerama }:

let
  rpathLibs = [ libXinerama libX11 ];
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

  buildInputs = rpathLibs;

  postInstall = ''
    for p in $out/bin/leftwm*; do
      patchelf --set-rpath "${lib.makeLibraryPath rpathLibs}" $p
    done
  '';

  dontPatchELF = true;

  meta = with lib; {
    description = "A tiling window manager for the adventurer";
    homepage = "https://github.com/leftwm/leftwm";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mschneider ];
    changelog = "https://github.com/leftwm/leftwm/blob/${version}/CHANGELOG";
  };
}
