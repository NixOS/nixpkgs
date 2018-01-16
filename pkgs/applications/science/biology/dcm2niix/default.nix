{ stdenv
, fetchFromGitHub
, cmake
, libyamlcpp
}:

stdenv.mkDerivation rec {
  version = "1.0.20170130";
  name = "dcm2niix-${version}";

  src = fetchFromGitHub {
    owner = "rordenlab";
    repo = "dcm2niix";
    rev = "v${version}";
    sha256 = "1f2nzd8flp1rfn725bi64z7aw3ccxyyygzarxijw6pvgl476i532";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ cmake ];
  buildInputs = [ libyamlcpp ];

  meta = with stdenv.lib; {
    description = "dcm2niix DICOM to NIfTI converter";
    longDescription = ''
      dcm2niix is a designed to convert neuroimaging data from the
      DICOM format to the NIfTI format.
    '';
    homepage = https://www.nitrc.org/projects/dcm2nii;
    license = licenses.bsd3;
    maintainers = [ maintainers.ashgillman ];
    platforms = platforms.all;
  };
}
