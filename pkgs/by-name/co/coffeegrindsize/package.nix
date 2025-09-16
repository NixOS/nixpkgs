{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication {
  pname = "coffeegrindsize";
  # no tags in the repo
  version = "0-unstable-2021-04-20";

  format = "other";

  src = fetchFromGitHub {
    owner = "jgagneastro";
    repo = "coffeegrindsize";
    rev = "22661ebd21831dba4cf32bfc6ba59fe3d49f879c";
    hash = "sha256-HlTw0nmr+VZL6EUX9RJzj253fnAred9LNFNgVHqoAoI=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    tkinter
    matplotlib
    numpy
    pandas
    pillow
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    echo "#!/usr/bin/env python" > "$out/bin/coffeegrindsize"
    cat coffeegrindsize.py >> "$out/bin/coffeegrindsize"
    chmod +x "$out/bin/coffeegrindsize"
    patchShebangs "$out/bin/coffeegrindsize"

    runHook postInstall
  '';

  meta = {
    description = "Detects the individual coffee grounds in a white-background picture to determine particle size distribution";
    mainProgram = "coffeegrindsize";
    homepage = "https://github.com/jgagneastro/coffeegrindsize";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ t4ccer ];
  };
}
