<<<<<<< HEAD
{ lib
, buildPythonApplication
, fetchFromGitHub
, configargparse
, setuptools
, poetry-core
, rbw

, waylandSupport ? false
, wl-clipboard
, wtype

, x11Support ? false
, xclip
, xdotool
}:

buildPythonApplication rec {
  pname = "rofi-rbw";
  version = "1.2.0";
=======
{ lib, buildPythonApplication, fetchFromGitHub, configargparse, setuptools, poetry-core, rbw }:

buildPythonApplication rec {
  pname = "rofi-rbw";
  version = "1.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "fdw";
    repo = "rofi-rbw";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-6ZM+qJvVny/h5W/+7JqD/CCf9eayExvZfC/z9rHssVU=";
=======
    hash = "sha256-5K6tofC1bIxxNOQ0jk6NbVoaGGyQImYiUZAaAmkwiTA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools
    poetry-core
  ];

<<<<<<< HEAD
  buildInputs = [
    rbw
  ] ++ lib.optionals waylandSupport [
    wl-clipboard
    wtype
  ] ++ lib.optionals x11Support [
    xclip
    xdotool
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [ configargparse ];

  pythonImportsCheck = [ "rofi_rbw" ];

<<<<<<< HEAD
  wrapper_paths = [
    rbw
  ] ++ lib.optionals waylandSupport [
    wl-clipboard
    wtype
  ] ++ lib.optionals x11Support [
    xclip
    xdotool
  ];

  wrapper_flags =
    lib.optionalString waylandSupport "--typer wtype --clipboarder wl-copy"
    + lib.optionalString x11Support "--typer xdotool --clipboarder xclip";

  preFixup = ''
    makeWrapperArgs+=(--prefix PATH : ${lib.makeBinPath wrapper_paths} --add-flags "${wrapper_flags}")
=======
  preFixup = ''
    makeWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ rbw ]})
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  meta = with lib; {
    description = "Rofi frontend for Bitwarden";
    homepage = "https://github.com/fdw/rofi-rbw";
    license = licenses.mit;
    maintainers = with maintainers; [ equirosa dit7ya ];
    platforms = platforms.linux;
<<<<<<< HEAD
    mainProgram = "rofi-rbw";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
