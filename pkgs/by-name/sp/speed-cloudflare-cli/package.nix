{
  lib,
  fetchFromGitHub,
  stdenv,
  nodejs,
}:
stdenv.mkDerivation {
  pname = "speed-cloudflare-cli";
  version = "2.0.3-unstable-2024-05-15";

  src = fetchFromGitHub {
    owner = "KNawm";
    repo = "speed-cloudflare-cli";
    rev = "dd301195e7def359a39cceeba16b1c0bedac8f5d";
    sha256 = "sha256-kxLeQUdJbkmApf5Af3Mgd3WvS3GhXXOIvA4gNB55TGM=";
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
