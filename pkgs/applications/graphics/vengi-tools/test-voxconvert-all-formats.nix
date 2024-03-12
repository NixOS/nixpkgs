{ stdenv
, vengi-tools
}:

stdenv.mkDerivation {
  name = "vengi-tools-test-voxconvert-all-formats";
  meta.timeout = 10;
  buildCommand = ''
    mkdir $out
    for format in vox qef qbt qb vxm vxr binvox gox cub vxl csv; do
      echo Testing $format export
      ${vengi-tools}/bin/vengi-voxconvert --input ${vengi-tools.src}/data/voxedit/chr_knight.qb --output $out/chr_knight.$format
    done
  '';
}
