{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "ariang";
  version = "1.3.10";

  src = fetchFromGitHub {
    owner = "mayswind";
    repo = "AriaNg";
    rev = version;
    hash = "sha256-YABoDBPrxII0uw4Cyy1A4AcLQ3Uo28dJa/F4LTI7f5Y=";
  };

  npmDepsHash = "sha256-cNTkdrJuXMhcBbbCYJ9Xs639T0QWUbhRABD2gQ2cfjM=";

  makeCacheWritable = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -r dist $out/share/ariang

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Modern web frontend making aria2 easier to use";
    homepage = "http://ariang.mayswind.net/";
    license = licenses.mit;
    maintainers = with maintainers; [ stunkymonkey ];
    platforms = platforms.unix;
  };
}
