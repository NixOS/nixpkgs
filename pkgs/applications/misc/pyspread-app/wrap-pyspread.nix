{ mkDerivation, lib, makeDesktopItem }:
args@{ pyspread
     , version ? pyspread.version # Pyspread version, use pyspread.version if not specified
     , pythonWithPackages ? null # Specified python interpreter
     , customInterpreterName ? null # Name of specified python interpreter (useful if you want something like pypy)
     , ...
     }:
let
_customInterpreterName = (
  if customInterpreterName != null
  then customInterpreterName
  else if (pythonWithPackages != null && lib.hasAttr "executable" pythonWithPackages)
  then pythonWithPackages.executable
  else null);

in mkDerivation (rec {

  pname = "pyspread-app";
  inherit version;

  dontUnpack = true;
  dontBuild = true;

  propagatedBuildInputs = [ pyspread ]
    ++ lib.lists.optional (pythonWithPackages != null) pythonWithPackages;

  desktopItem = makeDesktopItem rec {
    name = pname;
    exec = name;
    icon = name;
    desktopName = "Pyspread";
    genericName = "Spreadsheet";
    comment = meta.description;
    categories = "Development;Spreadsheet;";
    mimeType =
      "application/x-pyspread-spreadsheet;application/x-pyspread-bz-spreadsheet";
    startupNotify = "false";
  };

  installPhase = ''
    mkdir -p "$out/share"

    # Symlinking instead of copying to save space
    # Symlinking files and links
    # in ${pyspread}/lib/python*/site-packages/pyspread/share
    # from $out/share
    shareDefault=${pyspread}/${pyspread.pythonModule.sitePackages}/pyspread/share
    (
      cd $shareDefault;
      find . -mindepth 1 -type d -exec mkdir -p $out/share/{} \;
      find . -mindepth 1 -type f,l -exec ln -s $PWD/{} $out/share/{} \;
    )

    mkdir -p "$out/share/applications"
    cp $desktopItem/share/applications/* $out/share/applications

    mkdir -p "$out/bin"
    cp -r "${pyspread.outPath}/bin/." "$out/bin"
  '';

  dontWrapQtApps = true;
  preFixup = (lib.strings.optionalString (_customInterpreterName != null) ''
    sed -i -r 's/(python|pypy)[0-9]*m?\s+-m/'${_customInterpreterName}' -m/' $out/bin/pyspread
  '') + (if (pythonWithPackages != null) then ''
    wrapQtApp "$out/bin/pyspread" --prefix PATH : "${pythonWithPackages}/bin"
  '' else ''
    wrapQtApp "$out/bin/pyspread"
  '');

  meta = with lib; {
      description = "A non-traditional spreadsheet application that is based on and written in the programming language Python";
      longDescription = ''
        This is a package wrapping around python3Packages.pyspread
        to make it executable out of the box.
        It doesn't come with the libreary of the python module.
      '';
      homepage = "https://manns.github.io";
      license = licenses.gpl3;
      maintainers = with maintainers; [ ShamrockLee ];
    };
} // args)
