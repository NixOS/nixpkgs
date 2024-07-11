{ lib, stdenv, requireFile, bc, version, src, eulaDate }:

let
  license_dir = "~/.config/houdini";
in
stdenv.mkDerivation rec {
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

  meta = with lib; {
    description = "3D animation application software";
    homepage = "https://www.sidefx.com";
    license = licenses.unfree;
    platforms = platforms.linux;
    hydraPlatforms = [ ]; # requireFile src's should be excluded
    maintainers = with maintainers; [ canndrew kwohlfahrt ];
  };
}
