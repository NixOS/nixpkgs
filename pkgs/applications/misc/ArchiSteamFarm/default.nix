{ lib
, buildDotnetModule
, fetchFromGitHub
, dotnetCorePackages
, libkrb5
, zlib
, openssl
}:

buildDotnetModule rec {
  pname = "archisteamfarm";
  version = "5.1.5.3";

  src = fetchFromGitHub {
    owner = "justarchinet";
    repo = pname;
    rev = version;
    sha256 = "sha256-H038maKHZujmbKhbi8fxsKR/tcSPrcl9L5xnr77yyXg=";
  };

  dotnet-runtime = dotnetCorePackages.aspnetcore_5_0;
  nugetDeps = ./deps.nix;

  projectFile = "ArchiSteamFarm.sln";
  executables = [ "ArchiSteamFarm" ];

  runtimeDeps = [ libkrb5 zlib openssl ];

  # Without this, it attempts to write to the store even though the `--path` flag is supplied.
  patches = [ ./mutable-customdir.patch ];

  doCheck = true;

  preInstall = ''
    # A mutable path, with this directory tree must be set. By default, this would point at the nix store causing errors.
    makeWrapperArgs+=(
      --add-flags "--path ~/.config/archisteamfarm"
      --run "mkdir -p ~/.config/archisteamfarm/{config,logs,plugins}"
      --run "cd ~/.config/archisteamfarm"
    )
  '';

  passthru.updateScript = ./updater.sh;

  meta = with lib; {
    description = "Application with primary purpose of idling Steam cards from multiple accounts simultaneously";
    homepage = "https://github.com/JustArchiNET/ArchiSteamFarm";
    license = licenses.asl20;
    platforms = dotnetCorePackages.aspnetcore_5_0.meta.platforms;
    maintainers = with maintainers; [ SuperSandro2000 lom ];
  };
}
