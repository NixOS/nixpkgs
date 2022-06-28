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
  version = "2.8";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "hypnotix";
    rev = version;
    hash = "sha256-uj5Bn3K9SCKE4p1jylfQ8XnAwNnN4VXHLMLrwhKhzsk=";
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
    changelog = "https://github.com/linuxmint/hypnotix/blob/${src.rev}/debian/changelog";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
    platforms = lib.platforms.linux;
  };
}
