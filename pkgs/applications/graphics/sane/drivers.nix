{ lib, fetchFromGitHub }:

{
  # Fujitsu ScanSnap
  epjitsu = fetchFromGitHub {
    name = "scansnap-firmware";
    owner = "stevleibelt";
    repo = "scansnap-firmware";
    rev = "96c3a8b2a4e4f1ccc4e5827c5eb5598084fd17c8";
    sha256 = "1inchnvaqyw9d0skpg8hp5rpn27c09q58lsr42by4bahpbx5qday";
    meta.license = lib.licenses.unfree;
  };
}
