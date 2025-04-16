{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  makeWrapper,
  yarnBuildHook,
  yarnInstallHook,
  nodejs,
  xsel,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dokieli";
  version = "0-unstable-2024-12-12";

  # Can't update newer versions currently because newer versions require yarn-berry, and it's not in nixpkgs, yet.
  src = fetchFromGitHub {
    owner = "linkeddata";
    repo = "dokieli";
    rev = "d8dc72c81b84ec12f791892a6377a7f6ec46ed3b";
    hash = "sha256-CzSyQVyeJVOP8NCsa7ST3atG87V1KPSBzTRi0brMFYw=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash =
      if stdenv.hostPlatform.isDarwin then
        "sha256-bw5HszcHZ60qgYgm4qfhZEYXjJAQ2DXhWU0Reqb9VpQ="
      else
        "sha256-rwHBDBWZe4cdTyL7lNkB4nlpd5MWzbTU6kzdLBWcq0M=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp -r * $out
  '';

  nativeBuildInputs = [
    makeWrapper
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    # Needed for executing package.json scripts
    nodejs
  ];

  postFixup = ''
    makeWrapper ${nodejs}/bin/npx $out/bin/dokieli           \
      --prefix PATH : ${
        lib.makeBinPath ([
          nodejs
          xsel
        ])
      }   \
      --add-flags serve                                      \
      --chdir $out/deps/dokieli
  '';

  doDist = false;

  meta = {
    description = "dokieli is a clientside editor for decentralised article publishing, annotations and social interactions";
    homepage = "https://github.com/linkeddata/dokieli";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ shogo ] ++ lib.teams.ngi.members;
    mainProgram = "dokieli";
  };
})
