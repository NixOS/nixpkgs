{ stdenv, fetchurl, lib, xorg }:

let
  name = "scilab-bin-${ver}";

  ver = "6.0.1";

  majorVer = builtins.elemAt (lib.splitString "." ver) 0;

  badArch = throw "${name} requires i686-linux or x86_64-linux";

  architecture =
    if stdenv.system == "i686-linux" then
      "i686"
    else if stdenv.system == "x86_64-linux" then
      "x86_64"
    else
      badArch;
in
stdenv.mkDerivation rec {
  inherit name;

  src = fetchurl {
    url = "https://www.scilab.org/download/${ver}/scilab-${ver}.bin.linux-${architecture}.tar.gz";
    sha256 =
      if stdenv.system == "i686-linux" then
        "0fgjc2ak3b2qi6yin3fy50qwk2bcj0zbz1h4lyyic9n1n1qcliib"
      else if stdenv.system == "x86_64-linux" then
        "1scswlznc14vyzg0gqa1q9gcpwx05kz1sbn563463mzkdp7nd35d"
      else
        badArch;
  };

  libPath = lib.makeLibraryPath [
    stdenv.cc.cc
    xorg.libX11
    xorg.libXext
    xorg.libXi
    xorg.libXrender
    xorg.libXtst
    xorg.libXxf86vm
  ];

  phases = [ "unpackPhase" "fixupPhase" "installPhase" ];

  fixupPhase = ''
    sed -i 's|\$(/bin/|$(|g' bin/scilab
    sed -i 's|/usr/bin/||g' bin/scilab

    sci="$out/opt/scilab-${ver}"
    fullLibPath="$sci/lib/scilab:$sci/lib/thirdparty:$libPath"
    fullLibPath="$fullLibPath:$sci/lib/thirdparty/redist"

    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
             --set-rpath "$fullLibPath" bin/scilab-bin
    find . -name '*.so' -type f | while read file; do
      patchelf --set-rpath "$fullLibPath" "$file" 2>/dev/null
    done
  '';

  installPhase = ''
    mkdir -p "$out/opt/scilab-${ver}"
    cp -r . "$out/opt/scilab-${ver}/"
    mkdir "$out/bin"
    ln -s "$out/opt/scilab-${ver}/bin/scilab" "$out/bin/scilab-${ver}"
    ln -s "scilab-${ver}" "$out/bin/scilab-${majorVer}"
  '';

  meta = {
    homepage = http://www.scilab.org/;
    description = "Scientific software package for numerical computations (Matlab lookalike)";
    # see http://www.scilab.org/legal_notice
    license = "Scilab";
  };
}
