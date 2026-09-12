{
  lib,
  buildNimPackage,
  dbus,
  fetchFromGitHub,
  makeWrapper,
  openssl,
  testers,
}:

buildNimPackage (finalAttrs: {
  pname = "3code";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "capocasa";
    repo = "3code";
    tag = finalAttrs.version;
    hash = "sha256-AUJH7BKa5a6ApCj2cxth9wJbZjfjl2ISdd6BnJzf+jA=";
  };

  lockFile = ./lock.json;

  buildInputs = [ openssl ];

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    # buildNimPackage discovers only the standard `bin` field.
    substituteInPlace threecode.nimble \
      --replace-fail 'namedBin["threecode"] = "3code"' 'bin = @["threecode"]'
  '';

  nimFlags = [
    "-d:version=${finalAttrs.version}"
  ];

  doCheck = false; # Tests are not structured for buildNimPackage's test discovery.

  postInstall = ''
    mv $out/bin/threecode $out/bin/3code
    wrapProgram $out/bin/3code \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ dbus ]}
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "Economical coding agent for OpenAI-compatible endpoints";
    homepage = "https://3code.capocasa.dev";
    changelog = "https://github.com/capocasa/3code/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "3code";
    maintainers = with lib.maintainers; [ rvveber ];
    platforms = lib.platforms.linux;
  };
})
