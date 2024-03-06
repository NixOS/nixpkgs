{ lib
, buildGoModule
, fetchzip
}:

buildGoModule rec {
  pname = "dotcopy";
  version = "0.2.14";

  src = fetchzip {
    url = "https://github.com/FireSquid6/dotcopy/archive/refs/tags/v${version}.zip";
    hash = "sha256-oVMsIZUJ7xOBwSlJF+RUIYG0dPMTZ3ftDd9cpRytl7w=";
  };

  doCheck = false;
  vendorSha256 = null;

  subPackages = [ "." ];

  meta = with lib; {
    description = "A linux dotfile manager";
    homepage = "https://dotcopy.firesquid.co";
    license = licenses.gpl3;
    longDescription = ''
      Dotcopy is a linux dotfile manager that allows you to "compile" your dotfiles to use the same template for multiple machines.
    '';
    maintainers = with maintainers; [ firesquid6 ];
  };
}
