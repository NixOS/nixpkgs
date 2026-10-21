{
  atk,
  cairo,
  coreutils,
  fetchurl,
  gdk-pixbuf,
  glib,
  gtk3,
  lib,
  libglvnd,
  libx11,
  libxtst,
  libxxf86vm,
  makeWrapper,
  ocl-icd,
  openjdk17,
  pango,
  replaceVars,
  stdenv,
}:

let
  # Cytoscape bundles JavaFX (framework/lib/openjfx/linux); its native
  # libraries are extracted to ~/.openjfx at run time, so they cannot be
  # patched at build time and must find their dependencies through
  # LD_LIBRARY_PATH. libOpenCL is needed by the optional GPU (cycl) plugin.
  runtimeLibs = [
    atk
    cairo
    gdk-pixbuf
    glib
    gtk3
    libglvnd
    libx11
    libxtst
    libxxf86vm
    ocl-icd
    pango
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "cytoscape";
  version = "3.10.5";

  src = fetchurl {
    url = "https://github.com/cytoscape/cytoscape/releases/download/${finalAttrs.version}/cytoscape-unix-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-g5ViPcLhbyGQB1SIJZRwsniKO7+I3ieiYK00O44eo5s=";
  };

  patches = [
    # By default, gen_vmoptions.sh tries to store custom options in $out/share
    # at run time. This patch makes sure $HOME is used instead.
    (replaceVars ./gen_vmoptions_to_homedir.patch {
      inherit coreutils;
    })
    # Same for the karaf instance file, and teach the launcher to actually
    # read the vmoptions from $HOME/.cytoscape.
    ./runstate-to-homedir.patch
  ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ openjdk17 ] ++ runtimeLibs;

  installPhase = ''
    mkdir -pv $out/{share,bin}
    cp -Rv * $out/share/

    ln -s $out/share/cytoscape.sh $out/bin/cytoscape

    wrapProgram $out/share/cytoscape.sh \
      --set JAVA_HOME "${openjdk17}" \
      --set JAVA  "${openjdk17}/bin/java" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}"

    chmod +x $out/bin/cytoscape
  '';

  meta = {
    homepage = "http://www.cytoscape.org";
    description = "General platform for complex network analysis and visualization";
    mainProgram = "cytoscape";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.mimame ];
    platforms = lib.platforms.unix;
  };
})
