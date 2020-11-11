{ lib, stdenv
, fetchFromGitHub
, cmake
, libyamlcpp
, git
}:

stdenv.mkDerivation rec {
  version = "1.0.20201102";
  pname = "dcm2niix";

  src = fetchFromGitHub {
    owner = "rordenlab";
    repo = "dcm2niix";
    rev = "v${version}";
    sha256 = "0r21a55fd1fhkkrqqrynasvvnrbhzq0g3ifav2858hppdicw1j35";
  };

  nativeBuildInputs = [ cmake git ];
  buildInputs = [ libyamlcpp ];

  meta = with lib; {
    description = "DICOM to NIfTI converter";
    longDescription = ''
      dcm2niix is a designed to convert neuroimaging data from the
      DICOM format to the NIfTI format.
    '';
    homepage = "https://www.nitrc.org/projects/dcm2nii";
    license = licenses.bsd3;
    maintainers = [ maintainers.ashgillman ];
    platforms = platforms.all;
  };
}
