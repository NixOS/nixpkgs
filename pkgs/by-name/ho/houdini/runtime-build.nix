{
  stdenv,
  bc,
  version,
  src,
  eulaDate,
}:
stdenv.mkDerivation {
  inherit version src;
  pname = "houdini-runtime";

  buildInputs = [ bc ];
  installPhase = ''
    patchShebangs houdini.install
    mkdir -p $out
    ./houdini.install --install-houdini \
                      --install-license \
                      --no-install-menus \
                      --no-install-bin-symlink \
                      --auto-install \
                      --no-root-check \
                      --accept-EULA ${eulaDate} \
                      $out
    echo "licensingMode = localValidator" >> $out/houdini/Licensing.opt  # does not seem to do anything any more. not sure, official docs do not say anything about it
  '';

  dontFixup = true;
}
