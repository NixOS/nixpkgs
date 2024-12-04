{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "ogen";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "ogen-go";
    repo = "ogen";
    rev = "refs/tags/v${version}";
    hash = "sha256-gB9K+uRtTSPPy72F15Hagl22R5VD3vD8S455UOkOctA=";
  };

  # ogen reads version from runtime/debug buildinfo
  # which is not overridable as of now?
  postPatch = ''
    substituteInPlace internal/ogenversion/ogenversion.go \
      --replace-fail 'return m.Version, true' 'return "${version}", true'
  '';

  vendorHash = "sha256-Wdt5KiSIHWYZ8kak03rDFnZesYsX3UlIKwPYDRZqNBY=";

  subPackages = [
    "cmd/ogen"
    "cmd/jschemagen"
  ];

  # default checkPhase doesn't run anything
  # enabling test requires generating files and changing go.sum
  doCheck = false;

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "OpenAPI v3 Code Generator for Go";
    homepage = "https://github.com/ogen-go/ogen";
    changelog = "https://github.com/ogen-go/ogen/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ seanrmurphy ];
    mainProgram = "ogen";
  };
}
