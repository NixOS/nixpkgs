{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  makeWrapper,
}:

let
  pythonEnv = python3.withPackages (ps: [
    ps.tkinter
    ps.pyusb
  ]);
in
stdenv.mkDerivation rec {
  pname = "fusee-interfacee-tk";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "nh-server";
    repo = pname;
    rev = "V${version}";
    sha256 = "0ngwbwsj999flprv14xvhk7lp51nprrvcnlbnbk6y4qx5casm5md";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ pythonEnv ];

  installPhase = ''
    mkdir -p $out/bin

    # The program isn't just called app, so I'm renaming it based on the repo name
    # It also isn't a standard program, so we need to append the shebang to the top
    echo "#!${pythonEnv.interpreter}" > $out/bin/fusee-interfacee-tk
    cat app.py >> $out/bin/fusee-interfacee-tk
    chmod +x $out/bin/fusee-interfacee-tk

    # app.py depends on these to run
    cp *.py $out/bin/
    cp intermezzo.bin $out/bin/intermezzo.bin
  '';

  meta = with lib; {
    homepage = "https://github.com/nh-server/fusee-interfacee-tk";
    description = "Tool to send .bin files to a Nintendo Switch in RCM mode";
    mainProgram = "fusee-interfacee-tk";
    longDescription = "A mod of falquinhos Fusée Launcher for use with Nintendo Homebrew Switch Guide. It also adds the ability to mount SD while in RCM.
    Must be run as sudo.";
    maintainers = with maintainers; [ kristian-brucaj ];
    license = licenses.gpl2;
  };
}
