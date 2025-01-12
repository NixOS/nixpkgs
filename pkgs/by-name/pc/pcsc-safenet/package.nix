{ stdenv
, lib
, fetchzip
, autoPatchelfHook
, dpkg
, gtk3
, openssl
, pcsclite
}:

stdenv.mkDerivation rec {
  pname = "pcsc-safenet";
  version = "10.8.1050";

  debName = "Installation/Standard/Ubuntu-2204/safenetauthenticationclient_${version}_amd64.deb";

  # extract debian package from larger zip file
  src = fetchzip {
    # URL version name is different that the version name of the .deb file inside
    url = "https://www.digicert.com/StaticFiles/Linux_SAC_10_8_R1_GA.zip";
    hash = "sha256-Wh2Ax4ZVFKqn0yDwZmwvtUqwQNYyBng08IPfemHzZC0=";
  };

  dontBuild = true;
  dontConfigure = true;

  unpackPhase = ''
    dpkg-deb -x "$src/$debName" .
  '';

  buildInputs = [
    gtk3
    openssl
    pcsclite
  ];

  runtimeDependencies = [
    openssl
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  installPhase = ''
    mv usr/* .

    mkdir -p pcsc/drivers
    mv -- lib/pkcs11/* pcsc/drivers/
    rmdir lib/pkcs11

    mkdir "$out"
    cp -r ./* "$out/"

    # for each library like libfoo.so.1.2.3, create symlinks to it from libfoo.so, libfoo.so.1, libfoo.so.1.2
    (
      cd "$out/lib/" || exit
      for f in *.so.*.*.*; do                # find library names with three-layer suffixes
        ln -sf "$f" "''${f%.*}" || exit      # strip only one suffix layer
        ln -sf "$f" "''${f%.*.*}" || exit    # strip two suffix layers
        ln -sf "$f" "''${f%.*.*.*}" || exit  # strip all three suffix layers
      done
    ) || exit

    # when library links are missing in pcsc/drivers, create them
    (
      cd "$out/pcsc/drivers" || exit
      for f in *; do
        if [[ ! -e $f && -e ../../lib/$f ]]; then
          ln -sf ../../lib/"$f" "$f" || exit
        fi
      done
    ) || exit

    ln -sf ${lib.getLib openssl}/lib/libcrypto.so $out/lib/libcrypto.so.3
  '';

  dontAutoPatchelf = true;

  # Patch DYN shared libraries (autoPatchElfHook only patches EXEC | INTERP).
  postFixup = ''
    autoPatchelf "$out"

    runtime_rpath="${lib.makeLibraryPath runtimeDependencies}"

    for mod in $(find "$out" -type f -name '*.so.*'); do
      mod_rpath="$(patchelf --print-rpath "$mod")"
      patchelf --set-rpath "$runtime_rpath:$mod_rpath" "$mod"
    done;
  '';

  meta = with lib; {
    homepage = "https://safenet.gemalto.com/multi-factor-authentication/security-applications/authentication-client-token-management";
    description = "Safenet Authentication Client";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ wldhx ];
  };
}
