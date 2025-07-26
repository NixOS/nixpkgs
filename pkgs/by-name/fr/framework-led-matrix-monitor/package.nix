{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "framework-led-matrix-monitor";
  version = "1.0.0";
  pyproject = false; # No pyproject.toml or setup.py

  src = fetchFromGitHub {
    owner = "timoteuszelle";
    repo = "led-matrix";
    tag = "v${version}";
    hash = "sha256-/mdXCw8swTFaWAeoiAqWS/2sQzT12b5WGcwVZVv6h+E=";
  };

  propagatedBuildInputs = with python3Packages; [
    numpy
    psutil
    pyserial
    evdev
  ];

  # No tests available in upstream
  doCheck = false;

  # Manual installation since no setup.py
  installPhase = ''
        runHook preInstall

        mkdir -p $out/bin
        mkdir -p $out/share/framework-led-matrix-monitor

        # Copy all Python files
        cp *.py $out/share/framework-led-matrix-monitor/

        # Copy plugins directory
        cp -r plugins $out/share/framework-led-matrix-monitor/

        # Patch the plugins directory path in the Python files
        substituteInPlace $out/share/framework-led-matrix-monitor/led_system_monitor.py \
          --replace-fail "'./plugins/'" "'$out/share/framework-led-matrix-monitor/plugins/'"

        substituteInPlace $out/share/framework-led-matrix-monitor/drawing.py \
          --replace-fail "'./plugins/'" "'$out/share/framework-led-matrix-monitor/plugins/'" || true

        # Create the main executable wrapper
        cat > $out/bin/framework-led-matrix-monitor << EOF
    #!${python3Packages.python.interpreter}
    import sys
    sys.path.insert(0, '$out/share/framework-led-matrix-monitor')
    with open('$out/share/framework-led-matrix-monitor/led_system_monitor.py') as f:
        exec(f.read())
    EOF
        chmod +x $out/bin/framework-led-matrix-monitor

        runHook postInstall
  '';

  meta = with lib; {
    description = "System monitor for Framework 16 LED matrix modules";
    longDescription = ''
      A Python application that displays real-time system performance
      metrics on Framework 16 laptop LED matrix panels. Shows CPU utilization,
      memory usage, battery status, disk I/O, network activity, temperatures,
      and fan speeds across the left and right LED matrix modules.

      This package includes additional enhancements beyond the original,
      such as a plugin system, NixOS integration, and improved Linux support.
    '';
    homepage = "https://github.com/timoteuszelle/led-matrix";
    changelog = "https://github.com/timoteuszelle/led-matrix/blob/main/VERSION.md";
    license = lib.licenses.unfree; # Original upstream has no explicit license but is publicly shared
    maintainers = with lib.maintainers; [ timoteuszelle ];
    platforms = lib.platforms.linux;
    mainProgram = "framework-led-matrix-monitor";
  };
}
