{ lib, fetchFromGitHub, python3, makeDesktopItem, copyDesktopItems }:

with python3.pkgs;

buildPythonApplication rec {
  pname = "thonny";
  version = "4.1.4";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-f4wR5OPzWbtSqE+hSW2zD8u3pPl5nPTtGvf2LzOXjI4=";
  };

  nativeBuildInputs = [ copyDesktopItems ];

  desktopItems = [ (makeDesktopItem {
    name = "Thonny";
    exec = "thonny";
    icon = "thonny";
    desktopName = "Thonny";
    comment     = "Python IDE for beginners";
    categories  = [ "Development" "IDE" ];
  }) ];

  propagatedBuildInputs = with python3.pkgs; [
    jedi
    pyserial
    tkinter
    docutils
    pylint
    mypy
    pyperclip
    asttokens
    send2trash
    dbus-next
  ];

  preInstall = ''
    export HOME=$(mktemp -d)
  '';

  preFixup = ''
    wrapProgram "$out/bin/thonny" \
       --prefix PYTHONPATH : $PYTHONPATH:$(toPythonPath ${python3.pkgs.jedi})
  '';

  postInstall = ''
    install -Dm644 ./packaging/icons/thonny-48x48.png $out/share/icons/hicolor/48x48/apps/thonny.png
  '';

  # Tests need a DISPLAY
  doCheck = false;

  meta = with lib; {
    description = "Python IDE for beginners";
    longDescription = ''
      Thonny is a Python IDE for beginners. It supports different ways
      of stepping through the code, step-by-step expression
      evaluation, detailed visualization of the call stack and a mode
      for explaining the concepts of references and heap.
    '';
    homepage = "https://www.thonny.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ leenaars ];
    platforms = platforms.unix;
    mainProgram = "thonny";
  };
}
