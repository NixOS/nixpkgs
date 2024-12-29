{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "fiano";

  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "linuxboot";
    repo = "fiano";
    rev = "v${version}";
    hash = "sha256-QX0XMec99YbYWyfRThhwDaNjKstkUEz6wsisBynprmg=";
  };

  subPackages = [
    "cmds/cbfs"
    "cmds/create-ffs"
    "cmds/fmap"
    "cmds/fspinfo"
    "cmds/glzma"
    "cmds/guid2english"
    "cmds/microcode"
    "cmds/utk"
  ];

  vendorHash = "sha256-00ZSAVEmk2pNjv6fo++gnpIheK8lo4AVWf+ghXappnI=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Go-based tools for modifying UEFI firmware";
    homepage = "https://github.com/linuxboot/fiano";
    changelog = "https://github.com/linuxboot/fiano/blob/v${version}/RELEASES.md";
    license = licenses.bsd3;
    maintainers = [ maintainers.jmbaur ];
  };
}
