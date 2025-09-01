{
  lib,
  stdenv,
  fetchurl,
}:

let
  arch =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      "x64"
    else if stdenv.hostPlatform.system == "i686-linux" then
      "x86"
    else
      throwSystem;
  throwSystem = throw "Unsupported system: ${stdenv.hostPlatform.system}";
  sha256 =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      "0zy0jzvdqccfsg42m2lq1rj8r2c4iypd1h9vxl9824cbl92yim37"
    else if stdenv.hostPlatform.system == "i686-linux" then
      "03ml9xv19km99f0z7fpr21b1zkxvw7q39kjzd8wpb2pds51wnc62"
    else
      throwSystem;
  libraries = lib.makeLibraryPath [ stdenv.cc.cc ];

in
stdenv.mkDerivation rec {
  pname = "logmein-hamachi";
  version = "2.1.0.203";

  src = fetchurl {
    url = "https://vpn.net/installers/${pname}-${version}-${arch}.tgz";
    inherit sha256;
  };

  installPhase = ''
    patchelf \
      --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) \
      --set-rpath ${libraries} \
      hamachid
    install -D -m755 hamachid $out/bin/hamachid
    ln -s $out/bin/hamachid $out/bin/hamachi
  '';

  dontStrip = true;
  dontPatchELF = true;

  meta = with lib; {
    description = "Hosted VPN service that lets you securely extend LAN-like networks to distributed teams";
    homepage = "https://secure.logmein.com/products/hamachi/";
    changelog = "https://support.logmeininc.com/central/help/whats-new-in-hamachi";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfreeRedistributable;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
