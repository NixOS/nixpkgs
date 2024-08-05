{ lib
, fetchFromGitHub
, python3Packages
}:

python3Packages.buildPythonApplication {
  pname = "timew-sync-client";
  version = "1.0.1-unstable-2024-06-19";

  src = fetchFromGitHub {
    owner = "timewarrior-synchronize";
    repo = "timew-sync-client";
    rev = "90588baf3cf74e2270fa23f891f4d7077238fdca";
    hash = "sha256-k67iKIfAxYK3i0fbDWEMKr638mmeihd6VvVaYFLCfsw=";
  };

  pyproject = true;

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = with python3Packages; [
    requests
    jwcrypto
    pyjwt
    six
    colorama
  ];

  # no tests
  doCheck = false;

  meta = {
    description = "Client component of timewarrior synchronization application";
    mainProgram = "timew-sync-client";
    homepage = "https://github.com/timewarrior-synchronize/timew-sync-client";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ evris99 ];
  };
}
