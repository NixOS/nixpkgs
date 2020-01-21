{ stdenv
, fetchFromGitHub
, cmake
, libyamlcpp
, git
}:

stdenv.mkDerivation rec {
  version = "1.0.20190902";
  pname = "dcm2niix";

  src = fetchFromGitHub {
    owner = "rordenlab";
    repo = "dcm2niix";
    rev = "v${version}";
    sha256 = "0h8jsadgv831lqb0jhnaxm7lldirmnp5agrhgg5bcxvn860fl15b";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ cmake git ];
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
