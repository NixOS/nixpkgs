{ lib, stdenv, fetchFromGitHub, python3, bc, sassc, glib, libxml2, gdk-pixbuf
, gtk-engine-murrine
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "themix-theme-oomox";
  version = "1.12.r2.g0db28619";

  src = fetchFromGitHub {
    owner = "themix-project";
    repo = "oomox-gtk-theme";
    rev = "e0d729510791b4797e80610b73b5beea07673b10";
    sha256 = "1i0pj3hwpxcrwrx1y1yf9xxp38zcaljh7f8na3z3k77f1pldch27";
  };

  patches = [
     (fetchpatch {
       url = "https://github.com/themix-project/oomox-gtk-theme/commit/b695fcb8d303f804c53d85ad7d6396b0cd2b29b4.patch";
       sha256 = "0696bvj8pddf34pnljkxbnl2za6ah80a5rmjj89qjs122xg50n0d";
     })

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
