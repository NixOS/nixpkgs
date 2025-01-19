{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "shfm";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "dylanaraps";
    repo = pname;
    rev = version;
    hash = "sha256-ilVrUFfyzOZgjbBTqlHA9hLaTHw1xHFo1Y/tjXygNEs=";
  };

  postPatch = ''
    patchShebangs ./shfm
  '';

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -D shfm --target-directory $out/bin/
    install -D README --target-directory $out/share/doc/${pname}/
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/dylanaraps/shfm";
    description = "POSIX-shell based file manager";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.all;
    mainProgram = "shfm";
  };
}
