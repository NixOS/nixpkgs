{
  stdenv,
  fetchurl,
  lib,
  p7zip,
  patchelf,
  zlib,
  glibc
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ib-mgmt";
  version = "5.23.2";

  src = fetchurl {
    url = "https://www.mellanox.com/downloads/tools/mlnx_ib_mgmt-${finalAttrs.version}-1.el9.x86_64.rpm";
    sha256 = "sha256-rfxrHzxG6io+KTpaDBIbVHT3FVX5l4bSeYEVTXkgZ0A=";
  };

  nativeBuildInputs = [
    p7zip
    patchelf
  ];

  unpackPhase = ''
    7z x $src
    7z x mlnx_ib_mgmt-*.cpio
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    mv opt/mellanox/ib_mgmt/* $out/.
    mv usr/lib/systemd $out/lib/.
    for lib in $out/lib/*.so*;do
      if file -b "$lib" | grep -iq "ELF.*shared object"; then
        local libdir=$(dirname $lib)
        local libname=$(basename $lib)
        local base="''${libname%%.so.*}.so"
        local libvers="''${libname#''${base}.}"
        IFS='.' read -ra parts <<<"$libvers"
        PART_VER="''${parts[0]}"
        for ((i=0; i<''${#parts[@]}; i++));do
          if [[ $i -ne 0 ]]; then
            local PART_VER="$PART_VER.''${parts[$i]}"
          fi
          local ver=$PART_VER
          local link_name="''${base}.''${ver}"
          local target="$(basename $lib)"
          if [[ -e "$libdir/$link_name" && "$libdir/$link_name" != "$lib" ]] then
            rm $libdir/$link_name
          fi
          [[ ! -e "$libdir/$link_name" ]] && (cd $out/lib; ln -s $target $link_name; cd -)
        done
      fi
    done
    (cd $out/lib; ln -s libibumad_mlnx.so.3.3.0 libibumad.so.3; cd -)
    find $out -type d -exec chmod 0555 {} \;
    find $out -type f -exec chmod 0444 {} \;

    runHook postInstall
  '';

  postFixup =
    let
      pelf = patchelf + "/bin/patchelf";
    in
    ''
      patchShebangs .
      for bin in $out/bin/*;do
        if file --brief --mime-type "$bin" | grep -q '^application/x-executable$'; then
         ${pelf} \
            --set-interpreter $(${pelf} --print-interpreter ${pelf}) \
            --set-rpath ${
              lib.makeLibraryPath [
                zlib
                glibc
                (lib.getLib stdenv.cc.cc.lib)
              ]
            }:$out/lib \
            $bin
        fi
      done
      chmod +x $out/bin/*
    '';

  meta = {
    homepage = "https://network.nvidia.com/products/adapter-software/infiniband-management-and-monitoring-tools";
    description = "NVIDIA InfiniBand Management Tools";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ edwtjo ];
    mainProgram = "ibdiagnet";
    platforms = [
      "x86_64-linux"
    ];
  };
})
