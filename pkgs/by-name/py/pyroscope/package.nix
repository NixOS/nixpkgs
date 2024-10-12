{ lib
, buildGoModule
, buildNpmPackage
, fetchFromGitHub
, pkg-config
, nodePackages
, giflib
, pixman
, cairo
, pango
, testers
, pyroscope
}:
let
  pname = "pyroscope";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "pyroscope";
    rev = "v${version}";
    hash = "sha256-spgZUjeRegvhPsj1jZCL5canL8CSSaP7gG2MMso46rQ=";
  };
  ui = buildNpmPackage {
    inherit pname version src;

    nativeBuildInputs = [ pkg-config nodePackages.node-pre-gyp ];

    buildInputs = [
      giflib
      pixman
      cairo
      pango
    ];

    # Pyroscope uses Yarn, but it is really complex to make it work.
    # Where with Npm it is much simpler, their are poor chances that the result introduces bugs or errors.
    # If so try to regenerate the package-lock.json and update the patch.
    patches = [ ./package-lock-json.patch ];

    npmDepsHash = "sha256-8huOn96MGxNKmNar3smC0HHrR41T1iiXSHrYv9h+uMM=";

    npmPackFlags = [ "--ignore-scripts" ];

    npmFlags = [ "--legacy-peer-deps" ];

    makeCacheWritable = true;

    env.CYPRESS_INSTALL_BINARY = 0;

    installPhase = ''
      runHook preInstall

      cp -r public/build $out

      runHook postInstall
    '';
  };
in buildGoModule rec {
  inherit pname version src;

  vendorHash = "sha256-meIE8/4zgR9BHMA/48mPialhEeM4eqahdtTDukh6KtA=";

  subPackages = [ "cmd/pyroscope" "cmd/profilecli" ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/grafana/pyroscope/pkg/util/build.Branch=${src.rev}"
    "-X=github.com/grafana/pyroscope/pkg/util/build.Version=${version}"
    "-X=github.com/grafana/pyroscope/pkg/util/build.Revision=${src.rev}"
    "-X=github.com/grafana/pyroscope/pkg/util/build.BuildDate=now"
    "-extldflags '-static'"
  ];

  tags = [ "netgo" "embedassets" ];

  preBuild = ''
    cp -r ${ui} public/build
  '';

  CGO_ENABLED = 0;

  env.GOWORK = "off";

  passthru = {
    inherit ui;
    tests.version = testers.testVersion {
      inherit version;
      package = pyroscope;
      command = "pyroscope -version";
    };
  };

  meta = with lib; {
    changelog = "https://github.com/grafana/pyroscope/blob/${src.rev}/CHANGELOG.md";
    description = "Continuous Profiling Platform. Debug performance issues down to a single line of code";
    homepage = "https://github.com/grafana/pyroscope";
    license = licenses.agpl3Only;
    mainProgram = "pyroscope";
    maintainers = with maintainers; [ gaelreyrol ];
  };
}
