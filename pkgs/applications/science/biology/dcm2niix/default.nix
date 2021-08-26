{ lib, stdenv
, fetchFromGitHub
, cmake
, libyamlcpp
, git
}:

stdenv.mkDerivation rec {
  version = "1.0.20210317";
  pname = "dcm2niix";

  src = fetchFromGitHub {
    owner = "rordenlab";
    repo = "dcm2niix";
    rev = "v${version}";
    sha256 = "05rjk0xsrzcxa979vlx25k1rdz1in84gkfm9l1h9f7k4a4aa5r6j";
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
