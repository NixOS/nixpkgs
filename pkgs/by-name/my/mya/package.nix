{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  curl,
  json_c,
  libbsd,
  argp-standalone,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mya";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "jmakhack";
    repo = "myanimelist-cli";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-EmdkPpYEUIk9hr6rbnixjvznKSEnTCSMZz/17BfHGCk=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs =
    [
      curl
      json_c
      libbsd
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isGnu) [
      argp-standalone
    ];

  patches = [
    ./argp.patch
  ];

  installPhase = ''
    runHook preInstall

    # Based on the upstream PKGBUILD
    mkdir -p $out/share/doc/${finalAttrs.pname}
    cp -a bin $out
    cp $cmakeDir/README.md $out/share/doc/${finalAttrs.pname}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Minimalistic command line interface for fetching user anime data from MyAnimeList";
    longDescription = ''
      Minimalistic command line interface for fetching user anime data from MyAnimeList.

      You have to run this with the MYANIMELIST_CLIENT_ID environ variable set.
      Where to get one: <https://myanimelist.net/apiconfig>.
      Select the type `other`.
    '';
    homepage = "https://github.com/jmakhack/myanimelist-cli";
    changelog = "https://github.com/jmakhack/myanimelist-cli/releases/tag/v${finalAttrs.version}";
    license = licenses.mit;
    maintainers = with maintainers; [ pbsds ];
    mainProgram = "mya";
    platforms = platforms.all;
  };
})
