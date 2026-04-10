{
  stdenvNoCC,
  unzip,
  pname,
  version,
  src,
  passthru,
  meta,
}:

stdenvNoCC.mkDerivation {
  inherit
    pname
    version
    src
    passthru
    meta
    ;

  sourceRoot = "Postman.app";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications $out/bin
    cp --recursive . $out/Applications/Postman.app
    cat > $out/bin/postman << EOF
    #!${stdenvNoCC.shell}
    open -na $out/Applications/Postman.app --args "\$@"
    EOF
    chmod +x $out/bin/postman

    runHook postInstall
  '';

  # Postman is notarized on macOS. Running the fixup phase will change the shell scripts embedded
  # in the bundle, which causes the notarization check to fail on macOS 13+.
  # See https://eclecticlight.co/2022/06/17/app-security-changes-coming-in-ventura/ for more information.
  dontFixup = true;
}
