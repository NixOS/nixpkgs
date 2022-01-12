{ stdenv
, vengi-tools
}:

stdenv.mkDerivation {
  name = "vengi-tools-test-voxconvert-roundtrip";
  meta.timeout = 10;
  buildCommand = ''
    ${vengi-tools}/bin/vengi-voxconvert ${vengi-tools}/share/vengi-voxedit/chr_knight.qb chr_knight.vox
    ${vengi-tools}/bin/vengi-voxconvert chr_knight.vox chr_knight.qb
    ${vengi-tools}/bin/vengi-voxconvert chr_knight.qb chr_knight1.vox
    diff chr_knight.vox chr_knight1.vox
    touch $out
  '';
}
