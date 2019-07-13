{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "archiver";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "mholt";
    repo = pname;
    rev = "v${version}";
    sha256 = "1kq2cyhbniwdabk426j493cs8d4nj35vmznm9031rrdd9ln5h9gl";
  };

  modSha256 = "13vwgqpw7ypq6mrvwmnl8n38x0h89ymryrrzkf7ya478fp00vclj";

  meta = with lib; {
    description = "Easily create & extract archives, and compress & decompress files of various formats";
    homepage = "https://github.com/mholt/archiver";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.all;
  };
}
