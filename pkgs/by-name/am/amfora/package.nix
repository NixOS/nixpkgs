{
  stdenv,
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "amfora";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "makeworld-the-better-one";
    repo = "amfora";
    tag = "v${version}";
    hash = "sha256-6nY/wVqhSm+ZLA8ktrgmxoYiHK1r96aNbSf8+1YMXf8=";
  };

  vendorHash = "sha256-zZuFZtG0KKJ29t/9XyjRPIvyZqItxH2KwyKcAx3nuNM=";

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
