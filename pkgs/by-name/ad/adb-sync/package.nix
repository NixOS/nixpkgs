{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  makeWrapper,
  socat,
  go-mtpfs,
  adbfs-rootless,
  androidenv,
}:

stdenv.mkDerivation {
  pname = "adb-sync-unstable";
  version = "2019-01-01";

  src = fetchFromGitHub {
    owner = "google";
    repo = "adb-sync";
    rev = "fb7c549753de7a5579ed3400dd9f8ac71f7bf1b1";
    sha256 = "1kfpdqs8lmnh144jcm1qmfnmigzrbrz5lvwvqqb7021b2jlf69cl";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ python3 ];

  dontBuild = true;

  installPhase =
    let
      dependencies = lib.makeBinPath [
        androidenv.androidPkgs.platform-tools
        socat
        go-mtpfs
        adbfs-rootless
      ];
    in
    ''
      runHook preInstall

      mkdir -p $out/bin
      cp adb-{sync,channel} $out/bin

      wrapProgram $out/bin/adb-sync --suffix PATH : "${dependencies}"
      wrapProgram $out/bin/adb-channel --suffix PATH : "${dependencies}"

      runHook postInstall
    '';

  meta = with lib; {
    description = "Tool to synchronise files between a PC and an Android devices using ADB (Android Debug Bridge)";
    homepage = "https://github.com/google/adb-sync";
    license = licenses.asl20;
    platforms = platforms.unix;
    hydraPlatforms = [ ];
    maintainers = with maintainers; [ scolobb ];
  };
}
