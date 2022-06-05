{ lib
, stdenv
, fetchFromGitHub
, substituteAll
, cinnamon
, gettext
, gobject-introspection
, mpv
, python3
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "hypnotix";
  version = "2.6";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "hypnotix";
    rev = version;
    hash = "sha256-9HWr8zjUuhj/GZdrt1WwpwYNLEl34S9IJ7ikGZBSw3s=";
  };

  patches = [
    (substituteAll {
      src = ./libmpv-path.patch;
      libmpv = "${lib.getLib mpv}/lib/libmpv${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  postPatch = ''
    substituteInPlace usr/lib/hypnotix/hypnotix.py \
      --replace __DEB_VERSION__ ${version} \
      --replace /usr/share/hypnotix $out/share/hypnotix
  '';

  nativeBuildInputs = [
    gettext
    gobject-introspection
    python3.pkgs.wrapPython
    wrapGAppsHook
  ];

  dontWrapGApps = true;

  buildInputs = [
    cinnamon.xapps
  ];

  pythonPath = with python3.pkgs; [
    imdbpy
    pygobject3
    requests
    setproctitle
    unidecode
    xapp
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r usr/lib $out
    cp -r usr/share $out

    glib-compile-schemas $out/share/glib-2.0/schemas

    runHook postInstall
  '';

  preFixup = ''
    buildPythonPath "$out $pythonPath"
    makeWrapper ${python3.interpreter} $out/bin/hypnotix \
      --add-flags $out/lib/hypnotix/hypnotix.py \
      --prefix PYTHONPATH : "$program_PYTHONPATH" \
      ''${gappsWrapperArgs[@]}
  '';

  meta = {
    description = "IPTV streaming application";
    homepage = "https://github.com/linuxmint/hypnotix";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
    platforms = lib.platforms.linux;
  };
}
