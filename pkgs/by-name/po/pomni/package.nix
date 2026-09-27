{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  stdenv,
  darwin,
  nix-update-script,
}:

buildDotnetModule (finalAttrs: {
  pname = "pomni";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "drakon64";
    repo = "Pomni";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+AnPJKV+eLoSjlIZK+6oJLN2kEYpxeFROI/IXmhuSE8=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  projectFile = "src/Pomni.csproj";
  nugetDeps = ./deps.json;

  # Required for Native AOT
  nativeBuildInputs = [ stdenv.cc ];
  buildInputs = lib.optional stdenv.hostPlatform.isDarwin darwin.ICU;
  selfContainedBuild = true;

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = null; # No runtime required for Native AOT

  executables = [ "pomni" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Nix dependency locking and updating";
    homepage = "https://github.com/drakon64/Pomni";
    license = lib.licenses.eupl12;
    mainProgram = "pomni";
    maintainers = with lib.maintainers; [ drakon64 ];
  };
})
