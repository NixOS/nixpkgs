{
  lib,
  fetchFromGitHub,
  buildGoModule,
  stdenvNoCC,
  writableTmpDirAsHomeHook,
  buf,
  protoc-gen-go,
  protoc-gen-go-grpc,
  grpc-gateway,
  buildNpmPackage,
  installShellFiles,
  versionCheckHook,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "olivetin";
  version = "2025.11.25";

  src = fetchFromGitHub {
    owner = "OliveTin";
    repo = "OliveTin";
    tag = finalAttrs.version;
    hash = "sha256-HQLInEVXowWpDaSW/4bduUMdYsvQ0Rju1Rl2l9jupYA=";
  };

  patches = [ ./update-go-sum.patch ];

  modRoot = "service";

  vendorHash = "sha256-xSroaS6fwHrQ0s09uD3bkBZWWxbIndiOGL2JPvKzC6E=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  __darwinAllowLocalNetworking = true;

  gen = stdenvNoCC.mkDerivation {
    pname = "olivetin-gen";
    inherit (finalAttrs) version src;

    nativeBuildInputs = [
      writableTmpDirAsHomeHook
      buf
      protoc-gen-go
      protoc-gen-go-grpc
      grpc-gateway
    ];

    buildPhase = ''
      runHook preBuild

      pushd proto
      buf generate
      popd

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      cp -r service/gen $out

      runHook postInstall
    '';

    postFixup = ''
      find $out -type f -name '*.go' -exec \
        sed -i -E 's|//.*protoc-gen-go(-grpc)? +v.*$||' {} +
    '';

    outputHashMode = "recursive";
    outputHash = "sha256-wHqXsSV18mF/CfLQ0S4rGtT3QRcLnneYXAa8nXZaHpQ=";
  };

  webui = buildNpmPackage {
    pname = "olivetin-webui";
    inherit (finalAttrs) version src;

    npmDepsHash = "sha256-a1BBNlGusdMlmDXgclGqkO8AywSd4DTQKkuBVzuzAfE=";

    sourceRoot = "${finalAttrs.src.name}/webui.dev";

    buildPhase = ''
      runHook preBuild

      npx parcel build --public-url "."

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      cp -r dist $out
      cp -r *.png $out

      runHook postInstall
    '';
  };

  nativeBuildInputs = [ installShellFiles ];

  preBuild = ''
    ln -s ${finalAttrs.gen} gen
    substituteInPlace internal/config/config.go \
      --replace-fail 'config.WebUIDir = "./webui"' 'config.WebUIDir = "${finalAttrs.webui}"'
    substituteInPlace internal/httpservers/webuiServer_test.go \
      --replace-fail '"../webui/"' '"${finalAttrs.webui}"'
  '';

  postInstall = ''
    installManPage ../var/manpage/OliveTin.1.gz
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-version";
  doInstallCheck = true;

  passthru = {
    tests = { inherit (nixosTests) olivetin; };
    updateScript = ./update.sh;
  };

  meta = {
    description = "Gives safe and simple access to predefined shell commands from a web interface";
    homepage = "https://www.olivetin.app/";
    downloadPage = "https://github.com/OliveTin/OliveTin";
    changelog = "https://github.com/OliveTin/OliveTin/releases/tag/${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "OliveTin";
    knownVulnerabilities = [
      "CVE-2026-27626: OS Command Injection via password argument type and webhook JSON extraction bypasses shell safety checks"
      "CVE-2026-28342: Unauthenticated Denial of Service via Memory Exhaustion in PasswordHash API Endpoint"
      "CVE-2026-28789: Unauthenticated DoS via concurrent map writes in OAuth2 state handling"
      "CVE-2026-28790: Unauthenticated Action Termination via KillAction When Guests Must Login"
      "CVE-2026-30223: JWT Audience Validation Bypass in Local Key and HMAC Modes"
      "CVE-2026-30224: Session Fixation - Logout Fails to Invalidate Server-Side Session"
      "CVE-2026-30225: RestartAction always runs actions as guest"
      "CVE-2026-30233: View permission not being checked when returning dashboards"
      "CVE-2026-31817: Unsafe parsing of UniqueTrackingId can be used to write files"
    ];
  };
})
