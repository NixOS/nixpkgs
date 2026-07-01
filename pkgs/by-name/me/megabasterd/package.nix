{
  lib,
  fetchFromGitHub,
  jre,
  makeWrapper,
  maven,
}:
let
  version = "8.57";
in
maven.buildMavenPackage {
  pname = "megabasterd";
  inherit version;

  src = fetchFromGitHub {
    owner = "tonikelope";
    repo = "megabasterd";
    tag = "v${version}";
    hash = "sha256-6PKBzQA3lBa9/7J8bymGmnW3OPsRV4GgZ7dc7H6fOuE=";
  };

  mvnHash = "sha256-DVfPmW0ep6y/GxnwNKXxo68W5idcTkoNqUEKm7ouTEY=";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    jar_filename=MegaBasterd-${version}-jar-with-dependencies.jar

    mkdir -p $out/bin $out/share/megabasterd
    install -Dm644 target/$jar_filename $out/share/megabasterd

    makeWrapper ${jre}/bin/java $out/bin/megabasterd \
      --add-flags "-jar $out/share/megabasterd/$jar_filename"

    runHook postInstall
  '';

  meta = {
    description = "Yet another unofficial (and ugly) cross-platform MEGA downloader/uploader/streaming suite";
    homepage = "https://github.com/tonikelope/megabasterd";
    changelog = "https://github.com/tonikelope/megabasterd/releases";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ theobori ];
    mainProgram = "megabasterd";
  };
}
