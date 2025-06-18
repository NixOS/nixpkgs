{
  lib,
  fetchFromGitHub,
  buildGoModule,
  buildNpmPackage,
  makeWrapper,
  exiftool,
  ffmpeg,
  testers,
  photofield,
  nix-update-script,
}:

let
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "SmilyOrg";
    repo = "photofield";
    tag = "v${version}";
    hash = "sha256-ZPEkvh+wVudDz7h+5V8I90myyi4ksTU5B5ffI7DrCL0=";
  };

  webui = buildNpmPackage {
    inherit src version;
    pname = "photofield-ui";

    sourceRoot = "${src.name}/ui";

    npmDepsHash = "sha256-ULl4wHEo/PP0Y0O5po7eRDd+T/UjkZhQGIj262WFtFU=";

    installPhase = ''
      mkdir -p $out/share
      mv dist $out/share/photofield-ui
    '';
  };
in

buildGoModule {
  pname = "photofield";
  inherit version src;

  vendorHash = "sha256-m0RJgwDO+IcMCbtq2WZixMzZWtglHM6wpoPKOEU0CCw=";

  preBuild = ''
    cp -r ${webui}/share/photofield-ui ui/dist
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.builtBy=Nix"
  ];

  tags = [ "embedui" ];

  doCheck = false; # tries to modify filesytem

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/photofield \
      --prefix PATH : "${
        lib.makeBinPath [
          exiftool
          ffmpeg
        ]
      }"
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = photofield;
      command = "photofield -version";
    };
  };

  meta = with lib; {
    description = "Experimental fast photo viewer";
    homepage = "https://github.com/SmilyOrg/photofield";
    license = licenses.mit;
    mainProgram = "photofield";
    maintainers = with maintainers; [ dit7ya ];
  };
}
