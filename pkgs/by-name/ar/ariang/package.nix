{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "ariang";
  version = "1.3.9";

  src = fetchFromGitHub {
    owner = "mayswind";
    repo = "AriaNg";
    rev = version;
    hash = "sha256-c3+iyw8LgdB29552jJQr4q5P2ZW80jC0aN+eaenEYFo=";
  };

  npmDepsHash = "sha256-N7ZK6wthBYAt8tU8sJE0QChAYxWfJ1HG5P+AjXZfIiw=";

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
