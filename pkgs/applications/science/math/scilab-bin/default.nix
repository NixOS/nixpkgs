{ lib, stdenv, fetchurl, undmg, makeWrapper, xorg }:

let
  pname = "scilab-bin";
  version = "6.1.1";

  srcs = {
    aarch64-darwin = fetchurl {
      url = "https://www.utc.fr/~mottelet/scilab/download/${version}/scilab-${version}-accelerate-arm64.dmg";
      sha256 = "sha256-L4dxD8R8bY5nd+4oDs5Yk0LlNsFykLnAM+oN/O87SRI=";
    };
    x86_64-darwin = fetchurl {
      url = "https://www.utc.fr/~mottelet/scilab/download/${version}/scilab-${version}-x86_64.dmg";
      sha256 = "sha256-tBeqzllMuogrGcJxGqEl2DdNXaiwok3yhzWSdlWY5Fc=";
    };
    x86_64-linux = fetchurl {
      url = "https://www.scilab.org/download/${version}/scilab-${version}.bin.linux-x86_64.tar.gz";
      sha256 = "sha256-PuGnz2YdAhriavwnuf5Qyy0cnCeRHlWC6dQzfr7bLHk=";
    };
  };
  src = srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  meta = {
    homepage = "http://www.scilab.org/";
    description = "Scientific software package for numerical computations (Matlab lookalike)";
    platforms = [ "aarch64-darwin" "x86_64-darwin" "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.gpl2Only;
  };

  darwin = stdenv.mkDerivation rec {
    inherit pname version src meta;

    nativeBuildInputs = [ undmg makeWrapper ];

    sourceRoot = "scilab-${version}.app";

    installPhase = ''
      mkdir -p $out/{Applications/scilab.app,bin}
      cp -R . $out/Applications/scilab.app
      makeWrapper $out/{Applications/scilab.app/Contents/MacOS,bin}/scilab
    '';
  };

  linux = stdenv.mkDerivation rec {
    inherit pname version src meta;

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
  };
in
if stdenv.isDarwin then darwin else linux
