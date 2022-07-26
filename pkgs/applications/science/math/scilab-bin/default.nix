{ stdenv, fetchurl, lib, xorg }:

let
  badArch = throw "scilab-bin requires i686-linux or x86_64-linux";

  architecture =
    if stdenv.hostPlatform.system == "i686-linux" then
      "i686"
    else if stdenv.hostPlatform.system == "x86_64-linux" then
      "x86_64"
    else
      badArch;
in
stdenv.mkDerivation rec {
  pname = "scilab-bin";
  version = "6.1.1";

  src = fetchurl {
    url = "https://www.scilab.org/download/${version}/scilab-${version}.bin.linux-${architecture}.tar.gz";
    sha256 =
      if stdenv.hostPlatform.system == "i686-linux" then
        "0fgjc2ak3b2qi6yin3fy50qwk2bcj0zbz1h4lyyic9n1n1qcliib"
      else if stdenv.hostPlatform.system == "x86_64-linux" then
        "sha256-PuGnz2YdAhriavwnuf5Qyy0cnCeRHlWC6dQzfr7bLHk="
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

  fixupPhase = ''
    sed -i 's|\$(/bin/|$(|g' bin/scilab
    sed -i 's|/usr/bin/||g' bin/scilab

    sci="$out/opt/scilab-${version}"
    fullLibPath="$sci/lib/scilab:$sci/lib/thirdparty:$libPath"
    fullLibPath="$fullLibPath:$sci/lib/thirdparty/redist"

    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
             --set-rpath "$fullLibPath" bin/scilab-bin
    find . -name '*.so' -type f | while read file; do
      patchelf --set-rpath "$fullLibPath" "$file" 2>/dev/null
    done
  '';

  installPhase = ''
    mkdir -p "$out/opt/scilab-${version}"
    cp -r . "$out/opt/scilab-${version}/"

    # Create bin/ dir
    mkdir "$out/bin"

    # Creating executable symlinks
    ln -s "$out/opt/scilab-${version}/bin/scilab" "$out/bin/scilab"
    ln -s "$out/opt/scilab-${version}/bin/scilab-cli" "$out/bin/scilab-cli"
    ln -s "$out/opt/scilab-${version}/bin/scilab-adv-cli" "$out/bin/scilab-adv-cli"

    # Creating desktop config dir
    mkdir -p "$out/share/applications"

    # Moving desktop config files
    mv $out/opt/scilab-${version}/share/applications/*.desktop $out/share/applications

    # Fixing Exec paths and launching each app with a terminal
    sed -i -e "s|Exec=|Exec=$out/opt/scilab-${version}/bin/|g" \
           -e "s|Terminal=.*$|Terminal=true|g" $out/share/applications/*.desktop

    # Moving icons to the appropriate locations
    for path in $out/opt/scilab-${version}/share/icons/hicolor/*/*/*
    do
      newpath=$(echo $path | sed 's|/opt/scilab-${version}||g')
      filename=$(echo $path | sed 's|.*/||g')
      dir=$(echo $newpath | sed "s|$filename||g")
      mkdir -p $dir
      mv $path $newpath
    done

    # Removing emptied folders
    rm -rf $out/opt/scilab-${version}/share/{applications,icons}

    # Moving other share/ folders
    mv $out/opt/scilab-${version}/share/{appdata,locale,mime} $out/share
  '';

  meta = {
    homepage = "http://www.scilab.org/";
    description = "Scientific software package for numerical computations (Matlab lookalike)";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    # see http://www.scilab.org/legal_notice
    license = "Scilab";
  };
}
