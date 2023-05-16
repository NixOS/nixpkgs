<<<<<<< HEAD
{ lib, python3, fetchFromGitHub, fetchpatch, glibcLocales }:

python3.pkgs.buildPythonApplication rec {
=======
{ lib, python3Packages, fetchFromGitHub, glibcLocales }:

with python3Packages;

buildPythonApplication rec {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "topydo";
  version = "0.14";

  src = fetchFromGitHub {
<<<<<<< HEAD
    owner = "topydo";
=======
    owner = "bram85";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    repo = pname;
    rev = version;
    sha256 = "1lpfdai0pf90ffrzgmmkadbd86rb7250i3mglpkc82aj6prjm6yb";
  };

<<<<<<< HEAD
  patches = [
    # fixes a failing test
    (fetchpatch {
      name = "update-a-test-reference-ics-file.patch";
      url = "https://github.com/topydo/topydo/commit/9373bb4702b512b10f0357df3576c129901e3ac6.patch";
      hash = "sha256-JpyQfryWSoJDdyzbrESWY+RmRbDw1myvTlsFK7+39iw=";
    })
  ];

  propagatedBuildInputs = with python3.pkgs; [
    arrow
    glibcLocales
    icalendar
=======
  propagatedBuildInputs = [
    arrow
    icalendar
    glibcLocales
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    prompt-toolkit
    urwid
    watchdog
  ];

<<<<<<< HEAD
  nativeCheckInputs = with python3.pkgs; [
    freezegun
    unittestCheckHook
  ];
=======
  nativeCheckInputs = [ unittestCheckHook mock freezegun pylint ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Skip test that has been reported multiple times upstream without result:
  # bram85/topydo#271, bram85/topydo#274.
  preCheck = ''
    substituteInPlace test/test_revert_command.py --replace 'test_revert_ls' 'dont_test_revert_ls'
  '';

  LC_ALL = "en_US.UTF-8";

  meta = with lib; {
    description = "A cli todo application compatible with the todo.txt format";
<<<<<<< HEAD
    homepage = "https://github.com/topydo/topydo";
    changelog = "https://github.com/topydo/topydo/blob/${src.rev}/CHANGES.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
=======
    homepage = "https://github.com/bram85/topydo";
    license = licenses.gpl3;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
