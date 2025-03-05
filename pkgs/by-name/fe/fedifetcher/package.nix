{
  lib,
  fetchFromGitHub,
  python3,
  stdenv,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "fedifetcher";
  version = "7.1.15";
  format = "other";

  src = fetchFromGitHub {
    owner = "nanos";
    repo = "FediFetcher";
    tag = "v${version}";
    hash = "sha256-WGJIp7YTgMA3nHlOjLHFF1XTwRuiOf1QJmlBgzgfkNY=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    defusedxml
    python-dateutil
    requests
    xxhash
  ];

  installPhase = ''
    runHook preInstall

    install -vD find_posts.py $out/bin/fedifetcher

    runHook postInstall
  '';

  checkPhase = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    runHook preCheck

    $out/bin/fedifetcher --help>/dev/null

    runHook postCheck
  '';

  meta = with lib; {
    description = "Tool for Mastodon that automatically fetches missing replies and posts from other fediverse instances";
    longDescription = ''
      FediFetcher is a tool for Mastodon that automatically fetches missing
      replies and posts from other fediverse instances, and adds them to your
      own Mastodon instance.
    '';
    homepage = "https://blog.thms.uk/fedifetcher";
    changelog = "https://github.com/nanos/FediFetcher/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = teams.c3d2.members;
    mainProgram = "fedifetcher";
  };
}
