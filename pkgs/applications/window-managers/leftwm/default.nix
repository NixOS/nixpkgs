{ stdenv, lib, fetchFromGitHub, rustPlatform, libX11, libXinerama }:

let
  rpathLibs = [ libXinerama libX11 ];
in

rustPlatform.buildRustPackage rec {
  pname = "leftwm";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "leftwm";
    repo = "leftwm";
    rev = version;
    sha256 = "sha256-4f9YOVkOXn7+TzTUZS2Lultgj9WhiOPUa/fHUeyLBUU=";
  };

  cargoSha256 = "sha256-D00IFTELRlqeKQ7zheJKTvu5FBgYQXsZ+OnPnVzweC4=";

  buildInputs = rpathLibs;

  postInstall = ''
    for p in $out/bin/left*; do
      patchelf --set-rpath "${lib.makeLibraryPath rpathLibs}" $p
    done
  '';

  dontPatchELF = true;

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "A tiling window manager for the adventurer";
    homepage = "https://github.com/leftwm/leftwm";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
    changelog = "https://github.com/leftwm/leftwm/blob/${version}/CHANGELOG";
  };
}
