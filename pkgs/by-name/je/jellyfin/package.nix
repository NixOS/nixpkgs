{
  lib,
  fetchFromGitHub,
  fetchpatch,
  nixosTests,
  dotnetCorePackages,
  buildDotnetModule,
  jellyfin-ffmpeg,
  fontconfig,
  freetype,
  jellyfin-web,
  sqlite,
  versionCheckHook,
}:

buildDotnetModule (finalAttrs: {
  pname = "jellyfin";
  version = "10.11.11"; # ensure that jellyfin-web has matching version

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HCs4ZsutVoVH+bBZANjpPeMyV8e63Yemjg9DSr0R9zg=";
  };

  patches = [
    # Prevent SSRF, local file disclosure and DoS via external references in SVG rendering.
    # (No public PR.)
    (fetchpatch {
      url = "https://github.com/jellyfin/jellyfin/commit/cefa78fc1de2410e5c5c6da5062c98fe98b22d17.patch";
      hash = "sha256-TxGo+sLLG+C9omxrwvO6byzw+iRqONVLXrQKwkrY22s=";
    })

    # Fix MaxLoginAttempts not honored.
    # https://github.com/jellyfin/jellyfin/pull/17274
    (fetchpatch {
      url = "https://github.com/jellyfin/jellyfin/commit/8b826d981bcfec22063d6008e38016f4b77790d0.patch";
      hash = "sha256-Nav05TcpjBJABybU0BVyJ0UyxKi+6nDNBQ6tjY0DPT8=";
    })

    # GHSA-9x85-gx46-6522
    # Reject user impersonation when retrieving private playlist items.
    # (No public PR.)
    (fetchpatch {
      url = "https://github.com/jellyfin/jellyfin/commit/911ac3769cdcce50a8f6e0b3c0739d509bd9a23f.patch";
      hash = "sha256-MwaTwqhuBc7yWW3cL6htlyDQ9O1wt5iFCOM/oVTi6P0=";
    })

    # Don't let unauthorized users to list other's private playlists.
    # https://github.com/jellyfin/jellyfin/pull/17025
    ./fix-playlist-visibility.patch
  ];

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

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.tests = {
    smoke-test = nixosTests.jellyfin;
  };

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Free Software Media System";
    homepage = "https://jellyfin.org/";
    # https://github.com/jellyfin/jellyfin/issues/610#issuecomment-537625510
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      nyanloutre
      minijackson
      purcell
      jojosch
    ];
    mainProgram = "jellyfin";
    platforms = finalAttrs.dotnet-runtime.meta.platforms;
  };
})
