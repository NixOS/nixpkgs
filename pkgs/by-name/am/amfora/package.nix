{
  stdenv,
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "amfora";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "makeworld-the-better-one";
    repo = "amfora";
    rev = "v${version}";
    hash = "sha256-KOuKgxH3n4rdF+oj/TwEcRqX1sn4A9e23FNwQMhMVO4=";
  };

  vendorHash = "sha256-T/hnlQMDOZV+QGl7xp29sBGfb4VXcXqN6PDoBFdpp4M=";

  postInstall = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    sed -i "s:amfora:$out/bin/amfora:" amfora.desktop
    install -Dm644 amfora.desktop -t $out/share/applications
  '';

  meta = {
    description = "Fancy terminal browser for the Gemini protocol";
    mainProgram = "amfora";
    homepage = "https://github.com/makeworld-the-better-one/amfora";
    license = with lib.licenses; [ gpl3 ];
    maintainers = with lib.maintainers; [ deifactor ];
    changelog = "https://github.com/makeworld-the-better-one/amfora/blob/v${version}/CHANGELOG.md";
  };
}
