{ lib
, python3Packages
, gtk3
, cairo
, gnome
, librsvg
, xvfb-run
, dbus
, libnotify
, wrapGAppsHook
, fetchFromGitLab
, which
, gettext
, gobject-introspection
, gdk-pixbuf
, texlive
, imagemagick
, perlPackages
, writeScript
}:

let
  documentation_deps = [
    (texlive.combine {
      inherit (texlive) scheme-small wrapfig was;
    })
    xvfb-run
    imagemagick
    perlPackages.Po4a
  ];
  inherit (import ./src.nix { inherit fetchFromGitLab; }) version src sample_documents;
in

python3Packages.buildPythonApplication rec {
  inherit src version;
  pname = "paperwork";

  sample_docs = sample_documents // {
    # a trick for the update script
    name = "sample_documents";
    src = sample_documents;
  };

  sourceRoot = "source/paperwork-gtk";

  # Patch out a few paths that assume that we're using the FHS:
  postPatch = ''
    chmod a+w -R ..
    patchShebangs ../tools

    export HOME=$(mktemp -d)

    cat - ../AUTHORS.py > src/paperwork_gtk/_version.py <<EOF
    # -*- coding: utf-8 -*-
    version = "${version}"
    authors_code=""
    EOF
  '';

  preBuild = ''
    make l10n_compile
  '';

  postInstall = ''
    # paperwork-shell needs to be re-wrapped with access to paperwork
    cp ${python3Packages.paperwork-shell}/bin/.paperwork-cli-wrapped $out/bin/paperwork-cli
    # install desktop files and icons
    XDG_DATA_HOME=$out/share $out/bin/paperwork-gtk install --user

    # fixes [WARNING] [openpaperwork_core.resources.setuptools] Failed to find
    # resource file paperwork_gtk.icon.out/paperwork_128.png, tried at path
    # /nix/store/3n5lz6y8k9yks76f0nar3smc8djan3xr-paperwork-2.0.2/lib/python3.8/site-packages/paperwork_gtk/icon/out/paperwork_128.png.
    site=$out/lib/${python3Packages.python.libPrefix}/site-packages/paperwork_gtk
    for i in $site/data/paperwork_*.png; do
      ln -s $i $site/icon/out;
    done

    export XDG_DATA_DIRS=$XDG_DATA_DIRS:${gnome.adwaita-icon-theme}/share
    # build the user manual
    PATH=$out/bin:$PATH PAPERWORK_TEST_DOCUMENTS=${sample_docs} make data
    for i in src/paperwork_gtk/model/help/out/*.pdf; do
      install -Dt $site/model/help/out $i
    done
  '';

  checkInputs = [ dbus.daemon ];

  nativeBuildInputs = [
    wrapGAppsHook
    gobject-introspection
    (lib.getBin gettext)
    which
    gdk-pixbuf # for the setup hook
  ] ++ documentation_deps;

  buildInputs = [
    gnome.adwaita-icon-theme
    libnotify
    librsvg
    gtk3
    cairo
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  checkPhase = ''
    runHook preCheck

    # A few parts of chkdeps need to have a display and a dbus session, so we not
    # only need to run a virtual X server + dbus but also have a large enough
    # resolution, because the Cairo test tries to draw a 200x200 window.
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      $out/bin/paperwork-gtk chkdeps

    # content of make test, without the dep on make install
    python -m unittest discover --verbose -s tests

    runHook postCheck
  '';

  propagatedBuildInputs = with python3Packages; [
    paperwork-backend
    paperwork-shell
    openpaperwork-gtk
    openpaperwork-core
    pypillowfight
    pyxdg
    setuptools
  ];

  disallowedRequisites = documentation_deps;

  passthru.updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl common-updater-scripts
    version=$(list-git-tags | sed 's/^v//' | sort -V | tail -n1)
    update-source-version paperwork "$version" --file=pkgs/applications/office/paperwork/src.nix
    docs_version="$(curl https://gitlab.gnome.org/World/OpenPaperwork/paperwork/-/raw/$version/paperwork-gtk/src/paperwork_gtk/model/help/screenshot.sh | grep TEST_DOCS_TAG= | cut -d'"' -f2)"
    update-source-version paperwork.sample_docs "$docs_version" --file=pkgs/applications/office/paperwork/src.nix --version-key=rev
  '';

  meta = {
    description = "A personal document manager for scanned documents";
    homepage = "https://openpaper.work/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ aszlig symphorien ];
    platforms = lib.platforms.linux;
  };
}
