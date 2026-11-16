{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchurl,
  git,
  stdenvNoCC,
  testers,
  unzip,
}:

let
  common = finalAttrs: {
    __structuredAttrs = true;

    pname = "passlet";
    version = "0.11.0";

    passthru.tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      inherit (finalAttrs) version;
    };
    passthru.updateScript = ./update.sh;

    meta = {
      description = "Short-lived credentials for your agents";
      homepage = "https://passlet.dev";
      changelog = "https://github.com/ParetoSecurity/passlet/releases/tag/v${finalAttrs.version}";
      license = lib.licenses.mit;
      sourceProvenance = [
        (
          if stdenvNoCC.hostPlatform.isDarwin then
            lib.sourceTypes.binaryNativeCode
          else
            lib.sourceTypes.fromSource
        )
      ];
      maintainers = with lib.maintainers; [ zupo ];
      mainProgram = "passlet";
      platforms = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
    };
  };

in
if stdenvNoCC.hostPlatform.isDarwin then
  stdenvNoCC.mkDerivation (
    finalAttrs:
    common finalAttrs
    // {
      # Protected Keychain access needs upstream's Developer ID signature and
      # provisioning profile, which a build from source cannot have.
      src = fetchurl {
        url = "https://github.com/ParetoSecurity/passlet/releases/download/v${finalAttrs.version}/passlet_${finalAttrs.version}_macos.zip";
        hash = "sha256-GSk0JBc3mfZJESIvJ/3jwLOwbq0KmK0IC0fIoEURqWw=";
      };

      nativeBuildInputs = [ unzip ];
      sourceRoot = ".";
      dontConfigure = true;
      dontBuild = true;
      # Rewriting the Mach-O files would invalidate the signature.
      dontFixup = true;

      installPhase = ''
        runHook preInstall
        mkdir -p "$out/Applications" "$out/bin"
        cp -R Passlet.app "$out/Applications/"
        ln -s "$out/Applications/Passlet.app/Contents/MacOS/passlet" "$out/bin/passlet"
        runHook postInstall
      '';
    }
  )
else
  buildGoModule (
    finalAttrs:
    common finalAttrs
    // {
      src = fetchFromGitHub {
        owner = "ParetoSecurity";
        repo = "passlet";
        tag = "v${finalAttrs.version}";
        hash = "sha256-GPTHMexasGAZx7D+sz92qUtg0AsqSaalL1hPIJ6aW38=";
      };

      vendorHash = "sha256-gQi/bK7ioj4isjiPLke1LdUssDqfvUv8ws/xKvP1HP4=";
      nativeCheckInputs = [ git ];
      env.CGO_ENABLED = 0;
      # The Approver only works on macOS.
      tags = [ "agentonly" ];
      ldflags = [
        "-X=main.version=${finalAttrs.version}"
        "-s"
        "-w"
      ];
    }
  )
