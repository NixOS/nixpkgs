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
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "fdw";
    repo = "rofi-rbw";
    rev = "refs/tags/${version}";
    hash = "sha256-6ZM+qJvVny/h5W/+7JqD/CCf9eayExvZfC/z9rHssVU=";
  };

  nativeBuildInputs = [
    setuptools
    poetry-core
  ];

  buildInputs = [
    rbw
  ] ++ lib.optionals waylandSupport [
    wl-clipboard
    wtype
  ] ++ lib.optionals x11Support [
    xclip
    xdotool
  ];

  propagatedBuildInputs = [ configargparse ];

  pythonImportsCheck = [ "rofi_rbw" ];

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
  '';

  meta = with lib; {
    description = "Rofi frontend for Bitwarden";
    homepage = "https://github.com/fdw/rofi-rbw";
    license = licenses.mit;
    maintainers = with maintainers; [ equirosa dit7ya ];
    platforms = platforms.linux;
    mainProgram = "rofi-rbw";
  };
}
