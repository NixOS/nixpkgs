{ lib
, buildPythonPackage
, fetchFromGitHub

, poetry-core

, colorama
, cookiecutter
, matplotlib
, multiprocess
, numpy
, pnoise
, pyside2
, qasync
, shapely
, vpype
, watchfiles

, qt5
}:

buildPythonPackage rec {
  pname = "vsketch";
  version = "1.0.0-alpha.0";

  src = fetchFromGitHub {
    owner = "abey79";
    repo = "vsketch";
    rev = "0d937c851ac528bf182d0b71eb42ead525848c60";
    sha256 = "sha256-J04/yRAIMuCt6z+FT+bkV+h8sz7igg/mMyVsMOEMJhE=";
  };

  format = "pyproject";

  nativeBuildInputs = [ qt5.wrapQtAppsHook ];
  propagatedBuildInputs = [
    vpype pnoise qasync watchfiles
    shapely numpy pyside2
    colorama cookiecutter matplotlib multiprocess

    poetry-core
  ];

  postPatch = ''
    substituteInPlace pyproject.toml --replace 'vpype = {extras = ["all"], git = "https://github.com/abey79/vpype", rev = "6f28cef03ebae5d12420b9c14648bb3588c05e57"}' 'vpype = "^1.10.0"'
    sed -i '/PySide2/d' pyproject.toml # no idea why there isnt a dist-info written...
  '';

  dontWrapQtApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  postInstall = ''
    rm $out/lib/python*/site-packages/LICENSE
    rm $out/lib/python*/site-packages/README.md
  '';

  meta = with lib; {
    description = "Plotter generative art environment";
    homepage = "https://github.com/abey79/vsketch/";
    platforms = platforms.unix;
    maintainers = with maintainers; [rrix];
    license = with licenses; [ mit ];
  };
}
