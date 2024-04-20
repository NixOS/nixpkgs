{ stdenv
, lib
, fetchurl
, dpkg
, autoPatchelfHook
, zlib
, libgcc
, fontconfig
, libX11
, lttng-ust
, icu
, libICE
, libSM
, libXcursor
, openssl
, imagemagick
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lunacy";
  version = "9.5.0";

  src = fetchurl {
    url = "https://lcdn.icons8.com/setup/Lunacy_${finalAttrs.version}.deb";
    hash = "sha256-dG2xLoqRQJsaR7v00iN46GP4jB8WVrxayn2CSQLCUlQ=";
  };

  unpackCmd = ''
    mkdir -p root
    dpkg-deb -x $src root
  '';

  buildInputs = [
    zlib
    libgcc
    stdenv.cc.cc
    lttng-ust
    fontconfig.lib

    # Runtime deps
    libICE
    libSM
    libX11
    libXcursor
  ];

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  # adds to the RPATHS of all shared objects (exe and libs)
  appendRunpaths = map (pkg: (lib.getLib pkg) + "/lib") [
    icu
    openssl
    stdenv.cc.libc
    stdenv.cc.cc
  ] ++ [
    # technically, this should be in runtimeDependencies but will not work as
    # "lib" is appended to all elements in the array
    "${placeholder "out"}/lib/lunacy"
  ];

  # will add to the RPATH of executable only
  runtimeDependencies = [
    libICE
    libSM
    libX11
    libXcursor
  ];

  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib";
    cp -R "opt/icons8/lunacy" "$out/lib"
    cp -R "usr/share" "$out/share"

    # Prepare the desktop icon, the upstream icon is 200x200 but the hicolor theme does not
    # support this resolution. Nearest sizes are 192x192 and 256x256.
    ${imagemagick}/bin/convert "opt/icons8/lunacy/Assets/LunacyLogo.png" -resize 192x192 lunacy.png
    install -D lunacy.png "$out/share/icons/hicolor/192x192/apps/${finalAttrs.pname}.png"

    runHook postInstall
  '';

  postInstall = ''
    substituteInPlace $out/share/applications/lunacy.desktop \
      --replace "Exec=/opt/icons8/lunacy/Lunacy" "Exec=${finalAttrs.pname}" \
      --replace "Icon=/opt/icons8/lunacy/Assets/LunacyLogo.png" "Icon=${finalAttrs.pname}"
  '';

  postFixup = ''
    mkdir $out/bin

    # Fixes runtime error regarding missing libSkiaSharp.so (which is in the same directory as the binary).
    ln -s "$out/lib/lunacy/Lunacy" "$out/bin/${finalAttrs.pname}"
  '';

  meta = with lib; {
    description = "Free design software that keeps your flow with AI tools and built-in graphics";
    homepage = "https://icons8.com/lunacy";
    changelog = "https://lunacy.docs.icons8.com/release-notes/";
    license = licenses.unfree;
    maintainers = [ maintainers.eliandoran ];
    platforms = platforms.linux;
    sourceProvenance = [ sourceTypes.binaryBytecode ];
    mainProgram = "lunacy";
  };

})
