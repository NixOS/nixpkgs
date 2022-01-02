{ lib,
fetchFromGitHub,
python3Packages,
bash,
pywm,
}:

python3Packages.buildPythonApplication rec {
  pname = "newm";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "jbuchermn";
    repo = "newm";
    rev = "b6ef102";
    sha256 = "sha256-0nAjQxcZIuenFddpXqfatEvekwTnGIQUzAyhziMJLR4=";
  };

  propagatedBuildInputs = with python3Packages; [
    pywm
    pycairo
    psutil
    websockets
    python-pam
    pyfiglet
    fuzzywuzzy
  ];

  # Skip this as it tries to start the compositor
  setuptoolsCheckPhase = "true";

  LC_ALL = "en_US.UTF-8";

  meta =  with lib; {
    description = "Wayland compositor";
    longDescription = ''
      Tiling Wayland compositor written with touchpads and laptops in mind.
    '';
    homepage = "https://github.com/jbuchermn/newm";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jbuchermn ];
  };
}
