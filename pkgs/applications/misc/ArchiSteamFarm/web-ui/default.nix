{ lib, fetchFromGitHub, buildNpmPackage, nodePackages, ArchiSteamFarm }:

buildNpmPackage {
  pname = "asf-ui";
  inherit (ArchiSteamFarm) version;

  src = fetchFromGitHub {
    owner = "JustArchiNET";
    repo = "ASF-ui";
    # updated by the update script
    # this is always the commit that should be used with asf-ui from the latest asf version
    rev = "3078d92e8b8d79571b771f452a53d1789330c541";
    hash = "sha256-K3YTgsde9aqtmKuFKjXpoWe6USGpKBlC6eeazuOYTqk=";
  };

  npmDepsHash = "sha256-L+aWsGMUmIsPJRQ4XPg8WOWOqHKcfDQTqUK+vGBHi0Y=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -rv dist/* $out/

    runHook postInstall
  '';

  meta = with lib; {
    description = "The official web interface for ASF";
    license = licenses.apsl20;
    homepage = "https://github.com/JustArchiNET/ASF-ui";
    inherit (ArchiSteamFarm.meta) maintainers platforms;
  };
}
