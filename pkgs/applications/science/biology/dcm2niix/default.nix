{ stdenv
, fetchFromGitHub
, cmake
, libyamlcpp
}:

let
  version = "v1.0.20170130";
  sha256 = "1f2nzd8flp1rfn725bi64z7aw3ccxyyygzarxijw6pvgl476i532";

in stdenv.mkDerivation rec {
  name = "dcm2niix-${version}";

  src = fetchFromGitHub {
    inherit sha256;
    owner = "rordenlab";
    repo = "dcm2niix";
    rev = version;
  };

  enableParallelBuilding = true;
  buildInputs = [ cmake libyamlcpp];

  meta = {
    description = "dcm2niix DICOM to NIfTI converter";
    longDescription = ''
      dcm2niix is a designed to convert neuroimaging data from the
      DICOM format to the NIfTI format.
    '';
    homepage = https://www.nitrc.org/projects/dcm2nii;
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.ashgillman ];
    platforms = stdenv.lib.platforms.linux;
};
}
