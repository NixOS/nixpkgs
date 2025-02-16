{
  lib,
  stdenv,
  fetchFromGitHub,
  ant,
  jdk,
  hdf4,
  hdf5,
  makeDesktopItem,
  copyDesktopItems,
  strip-nondeterminism,
  stripJavaArchivesHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hdfview";
  version = "3.3.2";

  src = fetchFromGitHub {
    owner = "HDFGroup";
    repo = "hdfview";
    rev = "refs/tags/v${finalAttrs.version}";
    sha256 = "sha256-aJHeknkF38qDH9l+vuzdKFZZTcs/XMjtlHuu/LTF124=";
  };

  patches = [
    # Hardcode isUbuntu=false to avoid calling hostname to detect os
    ./0001-Hardcode-isUbuntu-false-to-avoid-hostname-dependency.patch
    # Disable signing on macOS
    ./disable-mac-signing.patch
    # Remove timestamp comment from generated versions.properties file
    ./remove-properties-timestamp.patch
  ];

  nativeBuildInputs = [
    ant
    jdk
    copyDesktopItems
    strip-nondeterminism
    stripJavaArchivesHook
  ];

  HDFLIBS = (hdf4.override { javaSupport = true; }).out;
  HDF5LIBS = (hdf5.override { javaSupport = true; }).out;

  buildPhase =
    let
      arch = if stdenv.hostPlatform.isx86_64 then "x86_64" else "aarch64";
    in
    ''
      runHook preBuild

      ant createJPackage -Dmachine.arch=${arch}

      runHook postBuild
    '';

  desktopItem = makeDesktopItem rec {
    name = "HDFView";
    desktopName = name;
    exec = name;
    icon = name;
    comment = finalAttrs.finalPackage.meta.description;
    categories = [
      "Science"
      "DataVisualization"
    ];
  };

  installPhase =
    ''
      runHook preInstall
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      mkdir -p $out/bin $out/lib
      cp -a build/dist/HDFView/bin/HDFView $out/bin/
      cp -a build/dist/HDFView/lib/app $out/lib/
      cp -a build/dist/HDFView/lib/libapplauncher.so $out/lib/
      ln -s ${jdk}/lib/openjdk $out/lib/runtime

      mkdir -p $out/share/applications $out/share/icons/hicolor/32x32/apps
      cp src/HDFView.png $out/share/icons/hicolor/32x32/apps/
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/Applications
      cp -a build/dist/HDFView.app $out/Applications/
    ''
    + ''
      runHook postInstall
    '';

  preFixup = ''
    # Remove build timestamp from javadoc files
    find $out/lib/app{,/mods}/doc/javadocs -name "*.html" -exec strip-nondeterminism --type javadoc {} +
  '';

  meta = {
    description = "A visual tool for browsing and editing HDF4 and HDF5 files";
    license = lib.licenses.free; # BSD-like
    homepage = "https://www.hdfgroup.org/downloads/hdfview";
    downloadPage = "https://github.com/HDFGroup/hdfview";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ jiegec ];
    mainProgram = "HDFView";
    # Startup issue is described here:
    # https://github.com/NixOS/nixpkgs/issues/340048 A possible solution is
    # suggested here:
    # https://forum.hdfgroup.org/t/building-hdfview-3-1-0-on-centos-6-swt-library-not-found/5698
    # But it requires us to update swt, which is a bit hard, the swt update is tracked here:
    # https://github.com/NixOS/nixpkgs/issues/219771
    broken = true;
  };
})
