{ picom, lib, fetchFromGitHub }:
picom.overrideAttrs (oldAttrs: rec {
  pname = "picom-pijulius";
  version = "e7b1488";

  src = fetchFromGitHub {
    owner = "pijulius";
    repo = "picom";
    rev = "${version}";
    sha256 = "1xi7bk8yicdvpn17cjws9q4xff8dcgl664i6pkdyhfwwg3j6j1b1";
    fetchSubmodules = true;
  };

  meta = with lib; {
    description = "Pijuliu's picom fork";
    homepage = "https://github.com/pijulius/picom";
    license = licenses.mpl20;
    mainProgram = "picom";
    maintainers = with maintainers; oldAttrs.meta.maintainers ++ [ YvesStraten ];
    platforms = platforms.linux;
  };
})
