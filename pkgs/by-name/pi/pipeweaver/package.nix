{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  pipewire,
  nix-update-script,
  stdenv,
}:

rustPlatform.buildRustPackage (
  finalAttrs:
  let
    web = buildNpmPackage {
      pname = "${finalAttrs.pname}-web";
      inherit (finalAttrs) version src;

      sourceRoot = "${finalAttrs.src.name}/web";

      npmDepsHash = "sha256-ZX/3H/VdRdWC2j+mPA/0rZflDhslqTN1mqA9vvQRQG0=";

      installPhase = ''
        runHook preInstall
        cp -r dist $out
        runHook postInstall
      '';
    };
  in
  {
    pname = "pipeweaver";
    version = "0.1.6";

    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "pipeweaver";
      repo = "pipeweaver";
      tag = "v${finalAttrs.version}";
      hash = "sha256-wf3gxCLT5vOz+5+CpfmkX0stKoAOpQ6KIoW6xBNV1xk=";
    };

    cargoHash = "sha256-Jv0fF6keg2NcUnCJhCId7rwPVZK1/Q9+otQNjp54RCI=";

    nativeBuildInputs = [
      pkg-config
      rustPlatform.bindgenHook
    ];

    buildInputs = [
      pipewire
    ];

    cargoBuildFlags = [
      "--workspace"
      "--exclude"
      "pipeweaver-app"
      "--all-features"
    ];

    cargoTestFlags = [
      "--workspace"
      "--exclude"
      "pipeweaver-app"
      "--all-features"
    ];

    postPatch = ''
      # Prevent daemon/build.rs from running to prevent impure git and npm calls.
      rm daemon/build.rs
      substituteInPlace daemon/Cargo.toml --replace-fail 'build = "build.rs"' ""

      mkdir -p daemon/web-content
      cp -r ${web}/* daemon/web-content/
    '';

    # Provide GIT_HASH that build.rs would have set
    env.GIT_HASH = finalAttrs.src.tag;

    installPhase = ''
      runHook preInstall

      releaseDir=target/${stdenv.hostPlatform.rust.cargoShortTarget}/release

      install -Dm755 $releaseDir/pipeweaver-daemon -t $out/bin
      install -Dm755 $releaseDir/pipeweaver-client -t $out/bin

      install -Dm644 daemon/resources/icons/pipeweaver.png \
        $out/share/icons/hicolor/48x48/apps/pipeweaver.png
      install -Dm644 daemon/resources/icons/pipeweaver.svg \
        $out/share/icons/hicolor/scalable/apps/pipeweaver.svg
      install -Dm644 daemon/resources/icons/pipeweaver-large.png \
        $out/share/pixmaps/pipeweaver.png
      install -Dm644 daemon/resources/desktop/pipeweaver.desktop \
        $out/share/applications/pipeweaver.desktop

      substituteInPlace $out/share/applications/pipeweaver.desktop \
        --replace-fail "Path=/usr/bin" "Path=$out/bin" \
        --replace-fail "Exec=/usr/bin/pipeweaver-daemon" "Exec=$out/bin/pipeweaver-daemon"

      install -Dm644 README.md $out/share/doc/pipeweaver/README.md
      install -Dm644 LICENSE $out/share/licenses/pipeweaver/LICENSE

      runHook postInstall
    '';

    passthru = {
      inherit web;
      updateScript = nix-update-script {
        extraArgs = [
          "--subpackage"
          "web"
        ];
      };
    };

    meta = {
      description = "Manage streaming audio on Linux through PipeWire with virtual channels, mixing, and routing";
      homepage = "https://github.com/pipeweaver/pipeweaver";
      license = lib.licenses.mit;
      mainProgram = "pipeweaver-daemon";
      platforms = lib.platforms.linux;
      maintainers = with lib.maintainers; [ saadndm ];
    };
  }
)
