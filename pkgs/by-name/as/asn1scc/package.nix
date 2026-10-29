{
  lib,
  pkgs,
  buildDotnetModule,
  callPackage,
  dotnetCorePackages,
  fetchFromGitHub,
  nix-update-script,
  testers,
}:
buildDotnetModule (finalAttrs: {
  pname = "asn1scc";
  version = "4.9.28.0";

  src = fetchFromGitHub {
    owner = "esa";
    repo = "asn1scc";
    tag = finalAttrs.version;
    hash = "sha256-0hyyeUIK3oAx16DvV4CqCrW131de0f7QLN5/EyU9Qf0=";
  };

  nativeBuildInputs = with pkgs; [ jre ];
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;

  executables = [ "asn1scc" ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      run = callPackage ./test.nix { asn1scc = finalAttrs.finalPackage; };
      version = testers.testVersion { package = finalAttrs.finalPackage; };
    };
  };

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    mainProgram = "asn1scc";
    homepage = "https://www.thanassis.space/asn1.html";
    description = "Open Source ASN.1 Compiler";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ cve ];
  };
})
