{
  fetchFromGitHub,
  callPackage,
  stdenv,
  makeWrapper,
  lib,
}:
let
  version = "2.3.13";
  pname = "photoview";
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v" + version;
    hash = "sha256-O6k5nbiWTsuOi8YLX0rsZJ9dOIo5d6pdwjhFZrdwI0E=";
  };
  backend = callPackage ./backend.nix { inherit src version; };
  frontend = callPackage ./frontend.nix { inherit src version; };
in
stdenv.mkDerivation {
  inherit pname version;
  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    ln -s ${backend}/bin/api $out/bin/photoview-backend
    wrapProgram $out/bin/photoview-backend \
      --set PHOTOVIEW_UI_PATH $out/lib/node_modules/photoview-ui/dist \
      --set PHOTOVIEW_SERVE_UI 1
    ln -s ${frontend}/lib $out/lib
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://photoview.github.io/";
    description = "Photo gallery for self-hosted personal servers";
    platforms = platforms.unix;
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ samw ];
    mainProgram = "photoview-backend";
  };
}
