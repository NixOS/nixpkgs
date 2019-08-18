{ stdenv
, fetchFromGitHub
, cmake
, libyamlcpp
, git
}:

stdenv.mkDerivation rec {
  version = "1.0.20190410";
  pname = "dcm2niix";

  src = fetchFromGitHub {
    owner = "rordenlab";
    repo = "dcm2niix";
    rev = "v${version}";
    sha256 = "1prwpvbi76xlpkhc4kadjhyyx0s71cs30hi6anknhfm6hdyd26ms";
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
