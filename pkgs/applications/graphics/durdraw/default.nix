{ lib
, python3Packages
, fetchFromGitHub
, ansilove
}:

python3Packages.buildPythonApplication rec {
  pname = "durdraw";
  version = "0.20.2";

  src = fetchFromGitHub {
    owner = "cmang";
    repo = pname;
    rev = version;
    hash = "sha256-J5kDnK0Fp2E/7aaBRB1kuew9g2uSdRQ84k0WFWco9SE=";
  };

  propagatedBuildInputs = [ ansilove ] ++ (with python3Packages; [ pillow ]);

  meta = with lib; {
    homepage = "http://durdraw.org";
    description = "ASCII art editor";
    longDescription = ''
      Durdraw is an ASCII, ANSI and Unicode art editor for UNIX-like systems
      (Linux, macOS, etc). It runs in the terminal and supports frame-based
      animation, custom themes, 256 color, terminal mouse input, IRC color
      export, Unicode and Code Page 437 block characters, and other interesting
      features.
    '';
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = with maintainers; [ foo-dogsquared ];
  };
}
