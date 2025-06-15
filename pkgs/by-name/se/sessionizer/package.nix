{ lib, pkgs, buildGoModule, }:
buildGoModule {
  pname = "sessionizer";
  version = "0.1.4";

  src = pkgs.fetchFromGitHub {
    owner = "salfel";
    repo = "sessionizer";
    rev = "v0.1.4";
    sha256 = "sha256-JZaJPxUEkUcNKB5EvoBuoMpiSZuB+q3hyl+tYjcI/ag=";
  };

  goPackagePath = "github.com/salfel/sessionizer";

  vendorHash = "sha256-04uCddd3+5YlAATkrNciHaem9lX/2P8AHDfRDH0ut7c=";

  proxyVendor = true;

  buildInputs = [ pkgs.fzf ];

  meta = with lib; {
    description =
      "Sessionizer helps you to search through your projects and creates custom tmux sessions for them";
    homepage = "https://github.com/salfel/sessionizer";
    license = licenses.gpl3;
    maintainers = with maintainers; [ salfel ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
