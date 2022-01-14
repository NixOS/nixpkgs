{ lib, fetchFromGitHub, rustPlatform, libX11, libXinerama }:

let
  rpathLibs = [ libXinerama libX11 ];
in

rustPlatform.buildRustPackage rec {
  pname = "leftwm";
  version = "0.2.10";

  src = fetchFromGitHub {
    owner = "leftwm";
    repo = "leftwm";
    rev = version;
    sha256 = "sha256-WGss/XmryULq8Ly5MFmEqsL+9r4fnrvBEtetngJ05NY=";
  };

  cargoSha256 = "sha256-9qvXzsAu4H2TAcArajrGqXwKF3BBDvmZbny7hiVO9Yo=";

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
