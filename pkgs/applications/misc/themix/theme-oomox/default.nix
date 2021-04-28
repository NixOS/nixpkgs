{ stdenv, fetchFromGitHub, python3, bc, sassc, glib, libxml2, gdk-pixbuf
, gtk-engine-murrine
}:

stdenv.mkDerivation rec {
  pname = "themix-theme-oomox";
  version = "1.12";

  src = fetchFromGitHub {
    owner = "themix-project";
    repo = "oomox-gtk-theme";
    rev = version;
    sha256 = "015yj9hl283dsgphkva441r1fr580wiyssm4s2x4xfjprqksxg8w";
  };

  patches = [
    # themix-gui generates customized theme by `cp -r` theme skeleton to
    # working directory and modifying it. As the skeleton is in nix store and
    # not writable, the copied one is not modifiable.
    ./writable.patch
  ];

  postPatch = ''
    patchShebangs .

    for bin in packaging/bin/*; do
        sed -i "$bin" -e "s@\(/opt/oomox/\)@$out\1@"
    done
  '';

  nativeBuildInputs = [ python3 ];

  propagatedBuildInputs = [ bc sassc glib libxml2 gdk-pixbuf ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  buildPhase = ''
    runHook preBuild
    python -O -m compileall .
    runHook postBuild
  '';

  # No tests
  doCheck = false; 

  makefile = "Makefile_oomox_plugin";

  installFlags = [ "DESTDIR=$(out)" "PREFIX=" ];

  postInstall = ''
    cp -r __pycache__ $out/opt/oomox/plugins/theme_oomox/
  '';

  meta = with lib; {
    description = "Oomox theme plugin for Themix GUI designer";
    homepage = "https://github.com/themix-project/oomox";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ mnacamura ];
    platforms = platforms.linux;
  };
}
