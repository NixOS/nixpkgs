{ stdenv, fetchFromGitHub, lib, autoreconfHook }:

stdenv.mkDerivation rec {
  version = "1.4.12";
  name = "tnef-${version}";

  src = fetchFromGitHub {
    owner = "verdammelt";
    repo = "tnef";
    rev = "${version}";
    sha256 = "02hwdaaa3yk0lbzb40fgxlkyhc1wicl6ncajpvfcz888z6yxps2c";
  };

  doCheck = true;

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "Unpacks MIME attachments of type application/ms-tnef";
    longDescription = ''
      TNEF is a program for unpacking MIME attachments of type "application/ms-tnef". This is a Microsoft only attachment.

      Due to the proliferation of Microsoft Outlook and Exchange mail servers, more and more mail is encapsulated into this format.

      The TNEF program allows one to unpack the attachments which were encapsulated into the TNEF attachment. Thus alleviating the need to use Microsoft Outlook to view the attachment.
    '';
    homepage = https://github.com/verdammelt/tnef;
    license = licenses.gpl2;
    maintainers = [ maintainers.DamienCassou ];
    platforms = platforms.all;
  };
}
