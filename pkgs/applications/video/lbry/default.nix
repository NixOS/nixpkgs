{ stdenv
, dpkg
, fetchurl
, at-spi2-core
, atomEnv
, ffmpeg
, gtk3
, libdrm
, libpulseaudio
, libuuid
, makeWrapper
, mesa
, xdg_utils
, xorg
}:

stdenv.mkDerivation rec {
  pname = "lbry-desktop";
  version = "0.48.2";

  src = fetchurl {
    url = "https://github.com/lbryio/lbry-desktop/releases/download/v${version}/LBRY_${version}.deb";
    sha256 = "0kqyiv9lfck9zzhiqpbvmlbyk09hajcaa2bpk1i3w03yk548an6z";
  };

  rpath = stdenv.lib.makeLibraryPath [
    at-spi2-core
    libdrm
    libpulseaudio
    libuuid
    mesa
    xorg.libXScrnSaver
    xorg.libxcb
  ] + ":${atomEnv.libPath}";

  buildInputs = [
    ffmpeg
    gtk3
  ];

  nativeBuildInputs = [ dpkg makeWrapper ];

  dontBuild = true;
  dontPatchELF = true;

  unpackPhase = ''
      dpkg --fsys-tarfile $src | tar --extract
      rm -rf usr/share/lintian
  '';

  installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      mv usr/* $out
      mv opt/LBRY $out/

      # Otherwise it looks "suspicious"
      chmod -R g-w $out

      for file in $(find $out -type f \( -perm /0111 -o -name \*.so\* \) ); do
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$file" || true
        patchelf --set-rpath ${rpath}:$out/LBRY $file || true
      done

      makeWrapper $out/LBRY/lbry $out/bin/lbry \
        --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
        --prefix PATH : ${ffmpeg}/bin:${xdg_utils}/bin

      # Fix the desktop link
      substituteInPlace $out/share/applications/lbry.desktop \
        --replace /opt/LBRY/ $out/bin/

      runHook postInstall
  '';

  meta = with stdenv.lib; {
    changelog = "https://github.com/lbryio/lbry-desktop/blob/master/CHANGELOG.md";
    description = "Official LBRY.tv desktop client";
    downloadPage = "https://lbry.com/get";
    homepage = "https://lbry.com";
    license = licenses.mit;
    maintainers = with maintainers; [ islandusurper ];
  };
}
