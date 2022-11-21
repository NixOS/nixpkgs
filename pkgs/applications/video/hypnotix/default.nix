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
  version = "2.9";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "hypnotix";
    rev = version;
    hash = "sha256-jjCyO6lyhqH4xeNp5uy/KqNr5Mvv+45pJGHFOXNi0rk=";
  };

  patches = [
    (substituteAll {
      src = ./libmpv-path.patch;
      libmpv = "${lib.getLib mpv}/lib/libmpv${stdenv.hostPlatform.extensions.sharedLibrary}";
    })

    # Fix launching with mpv 0.35.0 (ubuntu 22.04 doesn't have libmpv.so.2)
    # https://github.com/linuxmint/hypnotix/issues/254
    ./fix-deprecated-mpv-detach-destroy.patch
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
    cinnamon.xapp
  ];

  pythonPath = with python3.pkgs; [
    cinemagoer
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
    maintainers = with lib.maintainers; [ dotlambda bobby285271 ];
    platforms = lib.platforms.linux;
  };
}
