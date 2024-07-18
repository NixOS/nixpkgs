{
  lib,
  python3,
  fetchFromGitHub,
  ffmpeg,
  libav,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "swingmusic";
  version = "1.4.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "swingmx";
    repo = "SwingMusic";
    rev = "v${version}";
    hash = "sha256-Bm7RBmVRCRvAxculH9an05yj7Rta0yttCfyJnMvwbjI=";
  };

  nativeBuildInputs = [ python3.pkgs.poetry-core ];
  buildInputs = [
    ffmpeg
    libav
  ];
  propagatedBuildInputs = with python3.pkgs; [
    colorgram-py
    flask
    flask-compress
    flask-cors
    flask-restful
    locust
    pendulum
    pillow
    psutil
    rapidfuzz
    requests
    setproctitle
    show-in-file-manager
    tabulate
    tinytag
    tqdm
    unidecode
    waitress
    watchdog
  ];

  meta = with lib; {
    description = "A beautiful, self-hosted music player for your local audio files";
    homepage = "https://github.com/swingmx/SwingMusic";
    license = licenses.mit;
    maintainers = with maintainers; [ daru-san ];
    mainProgram = "swing-music";
  };
}
