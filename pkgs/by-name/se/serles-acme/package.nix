{ stdenv, python3 }:

let
  python = python3;
  serles-acme = python.pkgs.serles-acme;
in
stdenv.mkDerivation rec {
  inherit (serles-acme) pname version;
  inherit python;

  nativeBuildInputs = [ python.pkgs.wrapPython ];
  dontUnpack = true;

  pythonPath = [
    serles-acme
    python.pkgs.gunicorn
  ];

  gunicornScript = ''
    #!/bin/sh
    exec python -m gunicorn.app.wsgiapp "serles:create_app()" "$@"
  '';

  installPhase = ''
    runHook preInstall

    wrapPythonPrograms

    mkdir -p $out/bin

    echo "$gunicornScript" > $out/bin/serles
    chmod +x $out/bin/serles
    wrapProgram $out/bin/serles \
      --set PATH ${python.pkgs.python}/bin \
      --set PYTHONPATH $program_PYTHONPATH

    runHook postInstall
  '';

  meta = {
    inherit (serles-acme.meta) homepage description platforms maintainers license;
    mainProgram = "serles";
  };
}
