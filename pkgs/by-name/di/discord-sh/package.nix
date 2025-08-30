{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  curl,
  jq,
  coreutils,
  file,
}:

stdenvNoCC.mkDerivation rec {
  pname = "discord-sh";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "ChaoticWeg";
    repo = "discord.sh";
    rev = "v${version}";
    sha256 = "sha256-ZOGhwR9xFzkm+q0Gm8mSXZ9toXG4xGPNwBQMCVanCbY=";
  };

  # ignore Makefile by disabling buildPhase. Upstream Makefile tries to download
  # binaries from the internet for linting
  dontBuild = true;

  # discord.sh looks for the .webhook file in the source code directory, which
  # isn't mutable on Nix
  postPatch = ''
    substituteInPlace discord.sh \
      --replace 'thisdir="$(cd "$(dirname "$(readlink -f "''${BASH_SOURCE[0]}")")" && pwd)"' 'thisdir="$(pwd)"'
  '';

  nativeBuildInputs = [ makeWrapper ];

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/discord.sh --help

    runHook postInstallCheck
  '';

  installPhase = ''
    runHook preInstall
    install -Dm555 discord.sh $out/bin/discord.sh
    wrapProgram $out/bin/discord.sh \
      --set PATH "${
        lib.makeBinPath [
          curl
          jq
          coreutils
          file
        ]
      }"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Write-only command-line Discord webhook integration written in 100% Bash script";
    mainProgram = "discord.sh";
    homepage = "https://github.com/ChaoticWeg/discord.sh";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthewcroughan ];
  };
}
