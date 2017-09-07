{ stdenv, fetchurl, lib, xlibs }:

let
  name = "scilab-bin-${ver}";

  ver = "5.5.2";

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
    url = "http://www.scilab.org/download/${ver}/scilab-${ver}.bin.linux-${architecture}.tar.gz";
    sha256 =
      if stdenv.system == "i686-linux" then
        "6143a95ded40411a35630a89b365875a6526cd4db1e2865ac5612929a7db937a"
      else if stdenv.system == "x86_64-linux" then
        "c0dd7a5f06ec7a1df7a6b1b8b14407ff7f45e56821dff9b3c46bd09d4df8d350"
      else
        badArch;
  };

  libPath = lib.makeLibraryPath [
    stdenv.cc.cc
    xlibs.libX11
    xlibs.libXext
    xlibs.libXi
    xlibs.libXrender
    xlibs.libXtst
    xlibs.libXxf86vm
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
