{ lib
, buildPythonApplication
, fetchFromGitea
, gobject-introspection
, gtk3
, python3
, pygobject3
, wrapGAppsHook
}:

buildPythonApplication rec {
  pname = "KaiScr";
  version = "unstable-2020-10-21";

  src = fetchFromGitea {
    domain = "notabug.org";
    owner = "farooqkz";
    repo = pname;
    rev = "3ebb16d29075d09fe0bb69f5a00d57e107cae6c2";
    sha256 = "sha256-JnDjExGCfDKCvgH+h5QwYaTzaQ+2YEAkiSFrlw9PGOc=";
  };

  # src is plain Python3 scripts.
  format = "other";
  dontUseSetuptoolsBuild = true;
  dontUsePipInstall = true;
  dontUseSetuptoolsCheck = true;

  postPatch = ''
    # kailive is missing a shebang
    sed -ie '1i/#!/usr/bin/env python3' kailive.py
  '';

  nativeBuildInputs = [ wrapGAppsHook gobject-introspection ];
  buildInputs = [ gtk3 ];
  propagatedBuildInputs = [ pygobject3 ];

  installPhase = ''
    install -Dm755 kailive.py $out/bin/kailive
    install -Dm755 kaiscr.py $out/bin/kaiscr

    # kaiscr can be ran manually, but kailive also imports it:
    install -Dm555 kaiscr.py $out/lib/${python3.libPrefix}/site-packages/kaiscr.py
    export PYTHONPATH=$PYTHONPATH:$(toPythonPath "$out")
  '';

  checkPhase = ''
    runHook preCheck
    $out/bin/kaiscr -h
    runHook postCheck
  '';

  meta = with lib; {
    description = "Stream video and screenshot your KaiOS/FFOS device";
    homepage = "https://notabug.org/farooqkz/KaiScr";
    license = licenses.isc;
    maintainers = with maintainers; [ ckie ];
    mainProgram = "kaiscr";
  };
}
