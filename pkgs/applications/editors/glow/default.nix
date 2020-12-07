{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "glow";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "glow";
    rev = "v${version}";
    sha256 = "1jf9d8zwhvg9pc5g29lwz2r0lc59h1smwb5mjswxlvljpgbj7jwh";
  };

  vendorSha256 = "1p50qr7hbc8vyifa23z7xr43b4fpmwdzg7hqs503c124kpbpk45z";

  doCheck = false;

  buildFlagsArray = [ "-ldflags=" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "Render markdown on the CLI, with pizzazz!";
    homepage = "https://github.com/charmbracelet/glow";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne penguwin ];
  };
}
