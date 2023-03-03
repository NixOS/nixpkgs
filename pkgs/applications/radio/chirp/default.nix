{ lib
, fetchFromGitHub
, python3
, unstableGitUpdater
}:

python3.pkgs.buildPythonApplication rec {
  pname = "chirp";
  version = "unstable-2022-12-07";

  src = fetchFromGitHub {
    owner = "kk7ds";
    repo = "chirp";
    rev = "dc0c98d22423b496faf0a86296a6ec0bb3b3e11a";
    hash = "sha256-z0xD11CB7Vt8k0dPXE+E5ZD9XAFwWNxjnUs25/Gd7zI=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    future
    pyserial
    requests
    six
    wxPython_4_2
  ];

  # "running build_ext" fails with no output
  doCheck = false;

  passthru.updateScript = unstableGitUpdater {
    branch = "py3";
  };

  meta = with lib; {
    description = "A free, open-source tool for programming your amateur radio";
    homepage = "https://chirp.danplanet.com/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
