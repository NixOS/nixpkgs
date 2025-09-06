{
  lib,
  stdenv,
  fetchFromGitHub,
  gtk3,
  sassc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "adementary-theme";
  version = "201905r1";

  src = fetchFromGitHub {
    owner = "hrdwrrsk";
    repo = "adementary-theme";
    tag = finalAttrs.version;
    hash = "sha256-E18lmASOqYc+yItvuZF/eL8ErJ5u6sAjC0zk9FDQxZM=";
  };

  preBuild = ''
    # Shut up inkscape's warnings
    export HOME="$NIX_BUILD_ROOT"
  '';

  nativeBuildInputs = [ sassc ];
  buildInputs = [ gtk3 ];

  postPatch = "patchShebangs .";

  installPhase = ''
    mkdir -p $out/share/themes
    ./install.sh -d $out/share/themes
  '';

  meta = {
    description = "Adwaita-based GTK theme with design influence from elementary OS and Vertex GTK theme";
    homepage = "https://github.com/hrdwrrsk/adementary-theme";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
})
