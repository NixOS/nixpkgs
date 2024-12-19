{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "ariang";
  version = "1.3.8";

  src = fetchFromGitHub {
    owner = "mayswind";
    repo = "AriaNg";
    rev = version;
    hash = "sha256-B7gyBVryRn1SwUIqzxc1MYDS8l/mxMfJtE1/ZrBjC1E=";
  };

  npmDepsHash = "sha256-DmACToIdXfAqiXe13vevWrpWDY1YgRWVaTfdlk5uhPg=";

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
