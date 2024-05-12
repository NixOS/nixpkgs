{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  spicetify-cli,
}:

buildGoModule rec {
  pname = "spicetify-cli";
  version = "2.36.10";

  src = fetchFromGitHub {
    owner = "spicetify";
    repo = "spicetify-cli";
    rev = "v${version}";
    hash = "sha256-lwbd5sXqzC3H2GwmVqxAdt6Qcic00wh39l5Kp1UIYAs=";
  };

  vendorHash = "sha256-UPrLXzAdvCOmLm1tekzKyulQ4+2BSyPUF1k66GwKS88=";

  ldflags = [
    "-s -w"
    "-X 'main.version=${version}'"
  ];

  # used at runtime, but not installed by default
  postInstall = ''
    mv $out/bin/spicetify-cli $out/bin/spicetify
    ln -s $out/bin/spicetify $out/bin/spicetify-cli
    cp -r ${src}/jsHelper $out/bin/jsHelper
    cp -r ${src}/CustomApps $out/bin/CustomApps
    cp -r ${src}/Extensions $out/bin/Extensions
    cp -r ${src}/Themes $out/bin/Themes
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/spicetify --help > /dev/null
  '';

  passthru.tests.version = testers.testVersion { package = spicetify-cli; };

  meta = with lib; {
    description = "Command-line tool to customize Spotify client";
    homepage = "https://github.com/spicetify/spicetify-cli/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      jonringer
      mdarocha
    ];
    mainProgram = "spicetify";
  };
}
