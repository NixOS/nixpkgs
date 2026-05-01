{
  lib,
  fetchFromGitHub,
  stdenv,
  nodejs,
}:
stdenv.mkDerivation {
  pname = "speed-cloudflare-cli";
  version = "2.0.3-unstable-2025-07-31";

  src = fetchFromGitHub {
    owner = "KNawm";
    repo = "speed-cloudflare-cli";
    rev = "8eb34f4bd4f63493fbd93b1659389b9a1e5e4a36";
    sha256 = "sha256-kJ//zXBW2IQ5V5dJfAm8iGxf9QILH0uloNYiwG3pTe4=";
  };

  nativeBuildInputs = [ nodejs ];

  installPhase = ''
    mkdir -p $out/bin

    install -Dm755 $src/cli.js $out/bin/speed-cloudflare-cli
    install -Dm644 $src/chalk.js $out/bin/chalk.js
    install -Dm644 $src/stats.js $out/bin/stats.js

    patchShebangs $out/bin/speed-cloudflare-cli
  '';

  meta = {
    description = "Measure the speed and consistency of your internet connection using speed.cloudflare.com";
    homepage = "https://github.com/KNawm/speed-cloudflare-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ TheColorman ];
    mainProgram = "speed-cloudflare-cli";
    inherit (nodejs.meta) platforms;
  };
}
