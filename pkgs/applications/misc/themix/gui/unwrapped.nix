{ lib, stdenv, fetchFromGitHub, wrapGAppsHook, python3, gettext
, gtk3, gobject-introspection, hicolor-icon-theme
}:

stdenv.mkDerivation rec {
  pname = "themix-gui";
  version = "1.13.3";

  src = fetchFromGitHub {
    owner = "themix-project";
    repo = "oomox";
    rev = version;
    sha256 = "0j45cb34vsxx4azjidbrv5pm65asgmrzksl07b0xik5c3hvc2ksr";
  };

  patches = [ ./oomox_root.patch ];

  postPatch = ''
    patchShebangs .

    for bin in packaging/bin/*; do
        sed -i "$bin" -e "s@\(/opt/oomox/\)@$out\1@"
        sed -i "$bin" -e "s@exec \(python3\)@exec ${python3}/bin/\1@"
    done

    # No need to remove .git* in git submodules
    sed -i Makefile -e '/$(RM) -r .\+\.git\*/d'
  '';

  nativeBuildInputs = [ wrapGAppsHook ];

  buildInputs = [ python3 gettext gtk3 gobject-introspection hicolor-icon-theme ]
    ++ (with python3.pkgs; [ pygobject3 ]);

  buildPhase = ''
    runHook preBuild
    python -O -m compileall oomox_gui
    runHook postBuild
  '';

  # No tests
  doCheck = false;

  installFlags = [ "DESTDIR=$(out)" "PREFIX=" ];

  installTargets = "install_gui";

  postInstall = ''
    sed -i "$out/share/applications/com.github.themix_project.Oomox.desktop" \
        -e "s@Exec=\(oomox-gui\)@Exec=$out/bin/\1@"
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix PYTHONPATH : "$PYTHONPATH")
  '';

  meta = with lib; {
    description = "Plugin-based theme designer GUI for desktop/console environments";
    homepage = "https://github.com/themix-project/oomox";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ mnacamura ];
    platforms = platforms.linux;
  };
}
