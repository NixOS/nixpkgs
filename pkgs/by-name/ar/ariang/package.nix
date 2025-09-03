{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "ariang";
  version = "1.3.11";

  src = fetchFromGitHub {
    owner = "mayswind";
    repo = "AriaNg";
    rev = version;
    hash = "sha256-TisgE5VFOe/1LbDq43AHASMVhC85BglETYFcvsQpwMw=";
  };

  npmDepsHash = "sha256-wWy9XxwZvUo89kgxApHd3qZ2Bb4NgifQ96WRDsZvTGU=";

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
