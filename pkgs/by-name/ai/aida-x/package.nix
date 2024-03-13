{ lib, stdenv, fetchurl, autoPatchelfHook, dbus, alsaLib, libX11, libXext, libXrandr, libGL, ... }:

stdenv.mkDerivation rec {
  pname = "aida-x";
  version = "1.1.0";

  # Add autoPatchelfHook
  nativeBuildInputs = [ autoPatchelfHook ];
  # Metadata
  meta = with lib; {
    description = "AIDA-X, an Amp Model Player leveraging AI";
    homepage = "https://github.com/AidsDSP/AIDA-X";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };

  # Dependencies
  buildInputs = [ dbus alsaLib libX11 libXext libXrandr libGL ];
  # propagatedBuildInputs = [ ];

  # Source
  src = fetchurl {
    url = "https://github.com/AidaDSP/AIDA-X/releases/download/1.1.0/AIDA-X-${version
    }-linux-x86_64.tar.xz";
    sha256 = "KSuU9jXoreyV8jKA/JTxtt2VS4qUQPPlG36fqovb5UM=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    tar -xf $src -C $out/bin
  '';
}
