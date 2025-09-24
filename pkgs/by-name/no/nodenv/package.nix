{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "nodenv";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "nodenv";
    repo = "nodenv";
    rev = "v${version}";
    sha256 = "sha256-PGeZKL7qsffMAZIsCLB244Fuu48GyWw5Rh67ePu6h38=";
  };

  buildPhase = ''
    runHook preBuild

    bash src/configure
    make -C src

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r libexec $out/
    cp -r bin $out/

    runHook postInstall
  '';

  meta = {
    description = "Manage multiple NodeJS versions";
    mainProgram = "nodenv";
    homepage = "https://github.com/nodenv/nodenv/";
    changelog = "https://github.com/nodenv/nodenv/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ alexnortung ];
    platforms = lib.platforms.unix;
  };
}
