{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  bash,
  which,
  ffmpeg-full,
  makeBinaryWrapper,
}:
let
  version = "0.2.3";
in
buildGoModule {
  pname = "owncast";
  inherit version;
  src = fetchFromGitHub {
    owner = "owncast";
    repo = "owncast";
    rev = "v${version}";
    hash = "sha256-JCIB4G3cOSkEEO/jcsj4mUP+HeQfgn0jX4OL8NX9/C0=";
  };
  vendorHash = "sha256-FuynEBoPS0p1bRgmaeCxn1RPqbYHcltZpQ9SE71xHEE=";

  propagatedBuildInputs = [ ffmpeg-full ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  # lefthook is included as a tool in go.mod for a pre-commit hook, but causes the build to fail
  preBuild = ''
    # Remove lefthook from tools section in go.mod
    sed -i '/tool (/,/)/{ /[[:space:]]*github.com\/evilmartians\/lefthook[[:space:]]*$/d; }' go.mod
  '';

  postInstall = ''
    wrapProgram $out/bin/owncast \
      --prefix PATH : ${
        lib.makeBinPath [
          bash
          which
          ffmpeg-full
        ]
      }
  '';

  installCheckPhase = ''
    runHook preCheck
    $out/bin/owncast --help
    runHook postCheck
  '';

  passthru.tests.owncast = nixosTests.owncast;

  meta = with lib; {
    description = "Self-hosted video live streaming solution";
    homepage = "https://owncast.online";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      flexiondotorg
      MayNiklas
    ];
    mainProgram = "owncast";
  };
}
