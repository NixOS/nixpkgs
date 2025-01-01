{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  spicetify-cli,
}:

buildGoModule rec {
  pname = "spicetify-cli";
  version = "2.36.15";

  src = fetchFromGitHub {
    owner = "spicetify";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-K3lhPeW6L9N9OljNn8e6iQqx4k4HX5A9mX7SUlv2IRw=";
  };

  vendorHash = "sha256-i3xnf440lslzeDJ4pLLONqw8ACbdkKgPIhlPSuC1Vng=";

  ldflags = [
    "-s -w"
    "-X 'main.version=${version}'"
  ];

  # used at runtime, but not installed by default
  postInstall = ''
    mv $out/bin/cli $out/bin/spicetify
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
    homepage = "https://github.com/spicetify/cli";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.mdarocha ];
    mainProgram = "spicetify";
  };
}
