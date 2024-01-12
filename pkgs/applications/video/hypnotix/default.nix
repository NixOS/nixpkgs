{ lib
, stdenv
, fetchFromGitHub
, substituteAll
, cinnamon
, circle-flags
, gettext
, gobject-introspection
, mpv
, python3
, wrapGAppsHook
, yt-dlp
}:

stdenv.mkDerivation rec {
  pname = "hypnotix";
  version = "4.3";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "hypnotix";
    rev = version;
    hash = "sha256-nmldOziye+bSi8CA9TL0f3EKEKTeXRk3HFzf4ksE9oE=";
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
      --replace /usr/bin/yt-dlp ${yt-dlp}/bin/yt-dlp \
      --replace /usr/share/circle-flags-svg ${circle-flags}/share/circle-flags-svg \
      --replace /usr/share/hypnotix $out/share/hypnotix

    substituteInPlace usr/bin/hypnotix \
      --replace /usr/lib/hypnotix/hypnotix.py $out/lib/hypnotix/hypnotix.py
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
    python3 # for patchShebangs
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
    cp -r usr/* $out

    glib-compile-schemas $out/share/glib-2.0/schemas

    runHook postInstall
  '';

  preFixup = ''
    buildPythonPath "$out $pythonPath"

    # yt-dlp is needed for mpv to play YouTube channels.
    wrapProgram $out/bin/hypnotix \
      --prefix PATH : "${lib.makeBinPath [ yt-dlp ]}" \
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
    mainProgram = "hypnotix";
  };
}
