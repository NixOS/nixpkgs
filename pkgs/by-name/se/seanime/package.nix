{
  lib,
  fetchFromGitHub,
  buildGo126Module,
  buildNpmPackage,
  ffmpeg,
}:
let
  version = "3.5.0";
  src = fetchFromGitHub {
    owner = "5rahim";
    repo = "seanime";
    rev = "v${version}";
    hash = "sha256-5A2gg0ZFy9JP42I6fh9dcVUkS7P+0aH7arT4gdjAYHM=";
  };

  seanime-web = buildNpmPackage {
    pname = "seanime-web";

    inherit src version;

    sourceRoot = "${src.name}/seanime-web";

    patches = [ ./default-disable-update-check.patch ];

    npmDepsHash = "sha256-kO5k4B5mKoIfhhujNM0jw+/ErVwxm9/nZ5eBTWnA7HQ=";

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r out $out/web

      runHook postInstall
    '';
  };
in
buildGo126Module {
  pname = "seanime";

  inherit src version;

  vendorHash = "sha256-jdGkrU4WGgqkWN0FIaxVhtYfFnS+/ZnAY6dWB+gOmNQ=";

  preBuild = ''
    cp -r ${seanime-web}/web .

    # .github scripts redeclare main
    rm -rf .github
  '';

  subPackages = [ "." ];

  doCheck = false; # broken in clean environments

  ldflags = [
    "-s"
    "-w"
  ];

  makeWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        ffmpeg
      ]
    }"
  ];

  meta = {
    description = "Open-source media server for anime and manga";
    homepage = "https://seanime.app";
    changelog = "https://github.com/5rahim/seanime/blob/main/CHANGELOG.md";
    mainProgram = "seanime";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ thegu5 ];
  };
}
