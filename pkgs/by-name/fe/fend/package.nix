{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pandoc,
  pkg-config,
  openssl,
  installShellFiles,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,
  testers,
  writeText,
  runCommand,
  fend,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fend";
  version = "1.5.7";

  src = fetchFromGitHub {
    owner = "printfn";
    repo = "fend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3qEKYb8uYsTZ+UkpJkCKeGmY3iRQz9VfklE4LmcdA2E=";
  };

  cargoHash = "sha256-HzmRO7MDSVJHkeOWIKrEnaFmq68rCBcmWvXwQWGzA/s=";

  nativeBuildInputs = [
    pandoc
    installShellFiles
    pkg-config
    copyDesktopItems
  ];

  buildInputs = [
    pkg-config
    openssl
  ];

  postBuild = ''
    patchShebangs --build ./documentation/build.sh
    ./documentation/build.sh
  '';

  preFixup = ''
    installManPage documentation/fend.1
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    [[ "$($out/bin/fend "1 km to m")" = "1000 m" ]]
  '';

  postInstall = ''
    install -D -m 444 $src/icon/icon.svg $out/share/icons/hicolor/scalable/apps/fend.svg
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "fend";
      desktopName = "fend";
      genericName = "Calculator";
      comment = "Arbitrary-precision unit-aware calculator";
      icon = "fend";
      exec = "fend";
      terminal = true;
      categories = [
        "Utility"
        "Calculator"
        "ConsoleOnly"
      ];
    })
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      version = testers.testVersion { package = fend; };
      units = testers.testEqualContents {
        assertion = "fend does simple math and unit conversions";
        expected = writeText "expected" ''
          36 kph
        '';
        actual = runCommand "actual" { } ''
          ${lib.getExe fend} '(100 meters) / (10 seconds) to kph' > $out
        '';
      };
    };
  };

  meta = {
    description = "Arbitrary-precision unit-aware calculator";
    homepage = "https://github.com/printfn/fend";
    changelog = "https://github.com/printfn/fend/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      djanatyn
      liff
    ];
    mainProgram = "fend";
  };
})
