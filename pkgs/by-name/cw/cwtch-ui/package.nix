{
  cwtch,
  fetchgit,
  flutter329,
  lib,
  tor,
  _experimental-update-script-combinators,
  nix-update-script,
  runCommand,
  yq-go,
  dart,
}:
flutter329.buildFlutterApplication (finalAttrs: {
  pname = "cwtch-ui";

  version = "1.16.3";
  # This Gitea instance has archive downloads disabled, so: fetchgit
  src = fetchgit {
    url = "https://git.openprivacy.ca/cwtch.im/cwtch-ui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-w1bIT9EIwpmJ4fkOGKo6iI3HdkcYgrGlW0xeecpUn7g=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = lib.importJSON ./git-hashes.json;

  flutterBuildFlags = [
    "--dart-define"
    "BUILD_VER=${finalAttrs.version}"
    "--dart-define"
    "BUILD_DATE=1980-01-01-00:00"
  ];

  # These things are added to LD_LIBRARY_PATH, but not PATH
  runtimeDependencies = [ cwtch ];

  extraWrapProgramArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ tor ])
  ];

  postInstall = ''
    mkdir -p $out/share/applications
    substitute linux/cwtch.template.desktop "$out/share/applications/cwtch.desktop" \
      --replace-fail PREFIX "$out"
  '';

  passthru = {
    pubspecSource =
      runCommand "pubspec.lock.json"
        {
          inherit (finalAttrs) src;
          nativeBuildInputs = [ yq-go ];
        }
        ''
          yq eval --output-format=json --prettyPrint $src/pubspec.lock > "$out"
        '';
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script { })
      (
        (_experimental-update-script-combinators.copyAttrOutputToFile "cwtch-ui.pubspecSource" ./pubspec.lock.json)
        // {
          supportedFeatures = [ ];
        }
      )
      {
        command = [
          dart.fetchGitHashesScript
          "--input"
          ./pubspec.lock.json
          "--output"
          ./git-hashes.json
        ];
        supportedFeatures = [ ];
      }
    ];
  };

  meta = {
    description = "Messaging app built on the cwtch decentralized, privacy-preserving, multi-party messaging protocol";
    homepage = "https://cwtch.im/";
    changelog = "https://docs.cwtch.im/changelog";
    license = lib.licenses.mit;
    mainProgram = "cwtch";
    platforms = [ "x86_64-linux" ];
    maintainers = [ lib.maintainers.gmacon ];
  };
})
