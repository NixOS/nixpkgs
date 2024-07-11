{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle,
  makeWrapper,
  jre,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "piped-backend";
  version = "0-unstable-2024-07-10";

  src = fetchFromGitHub {
    owner = "TeamPiped";
    repo = "Piped-Backend";
    rev = "95a16effe503ae6f6ca11738c5ebfadbd703e0ac";
    hash = "sha256-RX+XQZnAfGb5zDstPLjnVvfu6Wuk0H76VvKl1hN1zhU=";
  };

  nativeBuildInputs = [ gradle makeWrapper ];

  gradleBuildTask = "shadowJar";

  installPhase = ''
    runHook preInstall

    install build/libs/piped-1.0-all.jar -Dt $out/share/java/

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${jre}/bin/java "$out/bin/${meta.mainProgram}" \
      --add-flags "-jar $out/share/java/piped-1.0-all.jar"
  '';

  mitmCache = gradle.fetchDeps {
    inherit pname;
    data = ./deps.json;
  };
  passthru.updateDeps = gradle.updateDeps { inherit pname; };
  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch=master" ]; };

  meta = {
    description = "The core component behind Piped, and other alternative frontends";
    homepage = "https://github.com/TeamPiped/Piped-Backend";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ atemu ];
    mainProgram = "piped-backend";
    platforms = lib.platforms.all;
  };
}
