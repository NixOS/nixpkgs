{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,
  python3,
}:

stdenvNoCC.mkDerivation {
  pname = "merge-ut-dictionaries";
  version = "0-unstable-2026-10-03";

  src = fetchFromGitHub {
    owner = "utuhiro78";
    repo = "merge-ut-dictionaries";
    rev = "6239884099ddc0c4d5bb1453b20441121d20593e";
    hash = "sha256-w8cOhDho/ayFb0bG2cRCeFZknRi6YSI7qm2+n6mnPB0=";
  };

  patches = [
    # Use Nix-provided local inputs instead of downloading mutable data.
    # Not upstreamed: this patch implements Nixpkgs' offline build workflow.
    ./merge-dictionaries-local-inputs.patch
  ];

  buildInputs = [ python3 ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 src/merge/merge_dictionaries.py "$out/bin/merge-ut-dictionaries"
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch"
    ];
  };

  meta = {
    description = "Merge additional UT dictionaries for Mozc";
    mainProgram = "merge-ut-dictionaries";
    homepage = "https://github.com/utuhiro78/merge-ut-dictionaries";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pineapplehunter ];
    platforms = lib.platforms.all;
  };
}
