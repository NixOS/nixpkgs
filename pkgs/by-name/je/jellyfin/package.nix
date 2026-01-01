{
  lib,
  fetchFromGitHub,
  nixosTests,
  dotnetCorePackages,
  buildDotnetModule,
  jellyfin-ffmpeg,
  fontconfig,
  freetype,
  jellyfin-web,
  sqlite,
<<<<<<< HEAD
  versionCheckHook,
}:

buildDotnetModule (finalAttrs: {
  pname = "jellyfin";
  version = "10.11.5"; # ensure that jellyfin-web has matching version
=======
}:

buildDotnetModule rec {
  pname = "jellyfin";
  version = "10.11.3"; # ensure that jellyfin-web has matching version
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin";
<<<<<<< HEAD
    tag = "v${finalAttrs.version}";
    hash = "sha256-MOzMSubYkxz2kwpvamaOwz3h8drEgeSoiE9Gwassmbk=";
=======
    rev = "v${version}";
    hash = "sha256-xNQe0hjY1BjC1D+hYTj1Gv2jCpwhWJv9dlvY6K9jkSk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  propagatedBuildInputs = [ sqlite ];

  projectFile = "Jellyfin.Server/Jellyfin.Server.csproj";
  executables = [ "jellyfin" ];
  nugetDeps = ./nuget-deps.json;
  runtimeDeps = [
    jellyfin-ffmpeg
    fontconfig
    freetype
  ];
  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_9_0;
  dotnetBuildFlags = [ "--no-self-contained" ];

  makeWrapperArgs = [
    "--add-flags"
    "--ffmpeg=${jellyfin-ffmpeg}/bin/ffmpeg"
    "--add-flags"
    "--webdir=${jellyfin-web}/share/jellyfin-web"
  ];

<<<<<<< HEAD
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  passthru.tests = {
    smoke-test = nixosTests.jellyfin;
  };

  passthru.updateScript = ./update.sh;

<<<<<<< HEAD
  meta = {
    description = "Free Software Media System";
    homepage = "https://jellyfin.org/";
    # https://github.com/jellyfin/jellyfin/issues/610#issuecomment-537625510
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Free Software Media System";
    homepage = "https://jellyfin.org/";
    # https://github.com/jellyfin/jellyfin/issues/610#issuecomment-537625510
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      nyanloutre
      minijackson
      purcell
      jojosch
    ];
    mainProgram = "jellyfin";
<<<<<<< HEAD
    platforms = finalAttrs.dotnet-runtime.meta.platforms;
  };
})
=======
    platforms = dotnet-runtime.meta.platforms;
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
