{
  lib,
  python3,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
  inputmodule-control,
  pulseaudio,
}:

python3.pkgs.buildPythonApplication (
  finalAttrs:
  let
    runtimeDeps = with python3.pkgs; [
      evdev
      numpy
      psutil
      pulsectl
      pynput
      pyserial
      python-dotenv
      pyyaml
      requests
      scipy
      sounddevice
    ];
  in
  {
    pname = "framework-led-matrix-monitor";
    version = "2.1.3";
    pyproject = false;

    src = fetchFromGitHub {
      owner = "timoteuszelle";
      repo = "led-matrix";
      tag = "v${finalAttrs.version}";
      hash = "sha256-E9sSK+H42DtLi+KGKnbGf5j5iM6rucMtckCtu5RkTjg=";
    };

    dependencies = runtimeDeps;

    nativeBuildInputs = [ makeWrapper ];

    # pyproject.toml still lists the pre-2.0 flat modules, so setuptools does
    # not install led_mon. Copy the package and wrap the real entry point.
    dontWrapPythonPrograms = true;

    installPhase = ''
      runHook preInstall

      site="$out/${python3.sitePackages}"
      mkdir -p "$site" "$out/bin" "$out/share/framework-led-matrix-monitor"
      cp -r led_mon main.py "$site/"
      cp led_mon/config.yaml "$out/share/framework-led-matrix-monitor/config.example.yaml"
      cp .env-example "$out/share/framework-led-matrix-monitor/.env-example"

      makeWrapper ${lib.getExe (python3.withPackages (_: runtimeDeps))} $out/bin/led-matrix-monitor \
        --add-flags "$site/main.py" \
        --prefix PYTHONPATH : "$site" \
        --prefix PATH : ${
          lib.makeBinPath [
            inputmodule-control
            pulseaudio
          ]
        }

      runHook postInstall
    '';

    # tests/ only contains a NixOS module fixture, not a Python test suite.
    doCheck = false;

    passthru.updateScript = nix-update-script { };

    meta = {
      description = "System monitor for Framework 16 LED matrix modules";
      homepage = "https://github.com/timoteuszelle/led-matrix";
      changelog = "https://github.com/timoteuszelle/led-matrix/blob/v${finalAttrs.version}/VERSION.md";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ timoteuszelle ];
      platforms = lib.platforms.linux;
      mainProgram = "led-matrix-monitor";
      longDescription = ''
        Displays live CPU, memory, battery, disk, network, temperature, and fan
        readings on Framework Laptop 16 LED matrix panels. Plugins add an audio
        equalizer and a time and weather display.

        IP-based weather lookup needs the Python package iplocate, which is not
        packaged in nixpkgs. Zip code and latitude/longitude lookups still work.
      '';
    };
  }
)
